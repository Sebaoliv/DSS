import 'package:flutter/material.dart';
import 'package:sissan_donantes/styles.dart';

class Logger {
  static const int maxLogCount = 100;
  List<String> logs = [];

  static Logger _instance;

  Logger._private();

  static Logger getLogger() {
    if (_instance == null) {
      _instance = Logger._private();
    }

    return _instance;
  }

  error(String text) {
    _log("ERROR", text);
  }

  info(String text) {
    _log("INFO", text);
  }

  _log(String type, String text) {
    logs.add("${DateTime.now()} - $type - $text");
    if (logs.length > maxLogCount) {
      logs.removeAt(0);
    }
  }
}

void error(String text) => Logger.getLogger().error(text);
void info(String text) => Logger.getLogger().info(text);

void showLog(BuildContext context) {
  showDialog(
      context: context,
      child: AlertDialog(
          title: Text("Últimos ${Logger.maxLogCount} logs"),
          content: Container(
            child: SingleChildScrollView(
              child: Text.rich(TextSpan(
                  text: Logger.getLogger().logs.join("\n\n"),
                  style: Styles.console)),
            ),
            color: Colors.black,
          )));
}
