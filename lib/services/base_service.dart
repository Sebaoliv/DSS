import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sissan_donantes/utilities/logger.dart' as logger; 



class BaseService {

  var _processAcceptableCertificates = (X509Certificate cert, String host, int port) => host == "doymisangre.com";
  List<String> logs = [];

  @protected
  Future<String> get(String url) async {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    HttpClient client = _getHttpClient();

    logger.info("Invoking GET $url");

    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();

    response.transform(utf8.decoder).listen((resultString) async{
      contents.write(resultString);
      logger.info("Invoking GET $url");
    })
    .onDone(() => completer.complete(contents.toString()));

    return completer.future;
  }

  @protected
  Future<dynamic> postJson(String url, Object value) async {
      var completer = new Completer<dynamic>();
      var contents = new StringBuffer();

      logger.info("Invoking POST $url");

      HttpClient client = _getHttpClient();
      var request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.write(jsonEncode(value));
      var response = await request.close();
      response.transform(utf8.decoder).listen((resultString) async {
         contents.write(resultString);
         logger.info("POST Result: " + resultString);
      })
      .onDone(() => completer.complete(jsonDecode(contents.toString())));

      return completer.future;
  }

 @protected
  Future<dynamic> postJsonStr(String url, Object value) async {
      var completer = new Completer<dynamic>();
      var contents = new StringBuffer();

      logger.info("Invoking POST $url");

      HttpClient client = _getHttpClient();
      var request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.write(jsonEncode(value));
      var response = await request.close();
      response.transform(utf8.decoder).listen((resultString) async {
         contents.write(resultString);
         logger.info("POST Result: " + resultString);
      })
      .onDone(() => completer.complete(contents.toString()));

      return completer.future;
  }



  HttpClient _getHttpClient() {
    var client = new HttpClient();
    client.badCertificateCallback = _processAcceptableCertificates;
    return client;
  }
}