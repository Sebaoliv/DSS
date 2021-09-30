import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sissan_donantes/home.dart';
import 'package:sissan_donantes/services/blood_bank_service.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';
import 'package:sissan_donantes/services/blood_bank_service_factory.dart';

void main() {
  runApp(
    MyApp(
      flag: false,
      optionalBloodBankCode: "",
      optionalCollectionPointCode: "",
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final bool flag;
  final String optionalBloodBankCode;
  final String optionalCollectionPointCode;
  MyApp(
      {Key key,
      @required this.flag,
      @required this.optionalBloodBankCode,
      @required this.optionalCollectionPointCode})
      : super(key: key);
  _MyAppState createState() => new _MyAppState();
}

enum UniLinksType { string, uri }

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String _latestLink = 'Unknown';
  String lastQr = "";
  String status = "";
  String bloodBankCode = "";
  String collectionPointCode = "";
  Future<String> qrUsed;
  Uri _latestUri;
  StreamSubscription _sub;
  TabController _tabController;
  UniLinksType _type = UniLinksType.string;
  BloodBankService _service;

   

  @override
  initState() {
    super.initState();
    _service = BloodBankServiceFactory.getInstance().getService();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabChange);
    initPlatformState();
  }

  Future<String> checkQRvalue() async {
    final pref = await SharedPreferences.getInstance();
    var res = pref.getString('UsedQR') ?? null;
    return res;
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    }
  }

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryParams = _latestUri?.queryParametersAll?.entries?.toList();
    if (queryParams != null) {
      if (!widget.flag) {
        var param = queryParams[0].key.toString();
        List<String> qrParameters = param.split(',');
        bloodBankCode = qrParameters[0];
        collectionPointCode = qrParameters[1];
      }
    } else if (widget.optionalBloodBankCode != "" &&
        widget.optionalCollectionPointCode != "") {
      bloodBankCode = widget.optionalBloodBankCode;
      collectionPointCode = widget.optionalCollectionPointCode;
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeWidget(
          bloodBankCode: bloodBankCode,
          collectionPointCode: collectionPointCode),
    );
  }

  _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _type = UniLinksType.values[_tabController.index];
      });
      initPlatformState();
    }
  }
}

List<Widget> intersperse(Iterable<Widget> list, Widget item) {
  List<Widget> initialValue = [];
  return list.fold(initialValue, (all, el) {
    if (all.length != 0) all.add(item);
    all.add(el);
    return all;
  });
}
