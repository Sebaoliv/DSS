import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sissan_donantes/appointment_selection.dart';
import 'package:sissan_donantes/contact_request_form_widget.dart';
import 'package:sissan_donantes/instructions.dart';
import 'package:sissan_donantes/services/blood_bank_service.dart';
import 'package:sissan_donantes/services/blood_bank_service_factory.dart';
import 'package:sissan_donantes/start.dart';
import 'package:sissan_donantes/main.dart';
import 'collection_points.dart';
import 'model/collection_day.dart';

class HomeWidget extends StatefulWidget {
  //HomeWidget({Key key}) : super(key: key);
  final String bloodBankCode;
  final String collectionPointCode;
  HomeWidget({Key key, @required this.bloodBankCode, this.collectionPointCode})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  Future<String> countryCode;
  Future<CollectionDay> collectionDay;
  CollectionDay _collectionDay;
  BloodBankService _service;
  PageController _controller;
  String code = "";
  String bankCode = "";
  String collectionCode = "";
  bool hasRecentAppointments = false;
  int lastAppointmentId;

  @override
  void initState() {
    super.initState();
    _service = BloodBankServiceFactory.getInstance().getService();
    Timer(Duration(seconds: 2), () {
      checkPermission();
       if (widget.bloodBankCode != "" && widget.collectionPointCode != "") {
      getCollectionPointData();
    }
    });

   
    _controller = PageController(initialPage: 0);
  }

  Widget _comesNormal() {
    return FutureBuilder(
        future: countryCode,
        builder: (context, data) {
          if (data.hasData) {
            return Scaffold(
                body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/test.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: PageIndicatorContainer(
                  length: 3,
                  pageView: PageView(
                    controller: _controller,
                    children: _getchildren(data.data),
                  ),
                  align: IndicatorAlign.bottom,
                  indicatorColor: Colors.grey,
                  indicatorSelectorColor: Colors.red,
                  size: 10.0,
                  indicatorSpace: 10.0,
                ),
              ),
            ));
          } else {
            return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/test.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child:CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 4,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.red))),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Detectando ubicación',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'para brindarte las jornadas de donación',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'que apliquen a tu país.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ));
          }
        });
  }

  Widget _comesFromQr() {
    if (_collectionDay == null) {
      getCollectionPointData();
      return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/test.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 4,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.red))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Cargando datos',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ],
          ));
    } else {
      return FutureBuilder(
          future: countryCode,
          builder: (context, data) {
            if (data.hasData) {
              return Scaffold(
                  body: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/test.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: PageIndicatorContainer(
                    length: 3,
                    pageView: PageView(
                      controller: _controller,
                      children: _getchildren(data.data),
                    ),
                    align: IndicatorAlign.bottom,
                    indicatorColor: Colors.grey,
                    indicatorSelectorColor: Colors.red,
                    size: 10.0,
                    indicatorSpace: 10.0,
                  ),
                ),
              ));
            } else {
              return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/test.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 4,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.red))),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 16.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Detectando ubicación',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 16.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'para brindarte las jornadas de donación',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 16.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'que apliquen a tu país.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ));
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Container(
        child:(widget.bloodBankCode!="" && widget.collectionPointCode!="")
         ? _comesFromQr()
         : _comesNormal(),
               decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/test.png"),
                      fit: BoxFit.cover,
                    ),
                  ), 
      );

  }

  List<Widget> _getchildren(String code) {
    if (code != null && code != "") {
      if (widget.bloodBankCode != null && widget.collectionPointCode != null) {
        if (widget.bloodBankCode == "" && widget.collectionPointCode == "") {
          //Si no viene por QR
          return <Widget>[
            StartPage(
              country: code,
              medicalCenter: "",
            ),
            InstructionsWidget(),
            CollectionPointsWidget(country: code)
          ];
        } else if (widget.bloodBankCode != "" &&
            widget.collectionPointCode != "") {
          //Si viene por QR con los dos codigos
          if (_collectionDay != null) {
            if (_collectionDay.availableAgenda == "S") {
              return <Widget>[
                StartPage(
                  country: code,
                  medicalCenter: widget.bloodBankCode,
                ),
                InstructionsWidget(),
                AppointmentSelectionWidget(
                  collectionPointDescription: _collectionDay.description,
                  useBackground: false,
                  jorColectaId: _collectionDay.id,
                  country: code,
                ),
              ];
            } else {
              return <Widget>[
                StartPage(
                  country: code,
                  medicalCenter: widget.bloodBankCode,
                ),
                InstructionsWidget(),
                ContactRequestFormWidget(
                  jorColectaId: _collectionDay.id,
                  jorColectaNombre: _collectionDay.description,
                  countryCode: code,
                  optionalAppointmentDate: null,
                  optionalAppointmentId: 0,
                )
              ];
            }
          } else {
            return <Widget>[
              InstructionsWidget(),
              CollectionPointsWidget(country: code)
            ];
          }
        } else {
          return <Widget>[
            StartPage(
              country: code,
              medicalCenter: "",
            ),
            InstructionsWidget(),
            CollectionPointsWidget(country: code)
          ];
        }
      } else {
        return <Widget>[
          StartPage(
            country: code,
            medicalCenter: "",
          ),
          InstructionsWidget(),
          CollectionPointsWidget(country: code)
        ];
      }
    } else {
      return <Widget>[
        StartPage(
          country: "",
          medicalCenter: "",
        )
      ];
    }
  }

  void getCollectionPointData() async {
    if (_service != null) {
      await _service
          .getJorColectaId(widget.bloodBankCode, widget.collectionPointCode)
          .then((onValue) {
        _service
            .getCollectionDay(int.parse(onValue))
            .whenComplete(() => setState(() {
                  _collectionDay = _service.collectionDay;
                }));
      });
    }
  }

  void checkPermission() async {
    if (await _hasGeolocationPermissionsGranted()) {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString('countryCode') ?? "";
 
      if (code == "") {
        _service.loadCountry().whenComplete(() => setState(() {
                 countryCode = _service.getCountry();
              _service.getCountry().then((onValue) {
                prefs.setString('countryCode', onValue);
              });
            }));
      } else {
        setState(() {
          // lastAppointmentId=lastId;
          countryCode = returnCountryCode();
        });
      }
    } else {
      _requestLocationPermission();
    }
  }

  Future<String> returnCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('countryCode') ?? "";
    return code;
  }

  Future<bool> _hasGeolocationPermissionsGranted() async {
    var geolocator = Geolocator();

    var geolocationStatus = await geolocator.checkGeolocationPermissionStatus();
    return (geolocationStatus.value == GeolocationStatus.granted.value) ||
        (geolocationStatus.value == GeolocationStatus.restricted.value);
  }

  void _showRationale() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Atención"),
          content: Text(
              '''Necesitamos su permiso para conocer el país donde se encuentra y poder mostrarle los bancos de sangre disponibles cerca de usted. 
                             Esta información no se comparte con nuestro servidor ni con terceros. Agradecemos nos de acceso.'''),
          actions: <Widget>[
            FlatButton(
              child: Text("Dar acceso"),
              onPressed: () {
                openAppSettings();
                // Phoenix.rebirth(context);
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  void _requestLocationPermission() async {
    var result = await Permission.location.request();
    if (result.isPermanentlyDenied) {
      _showRationale();
    } else if (result.isDenied) {
      _showRationale();
    } else {
      runApp(new MyApp(
        flag: true,
        optionalBloodBankCode: "",
        optionalCollectionPointCode: "",
        key: UniqueKey(),
      ));
    }
  }
}
