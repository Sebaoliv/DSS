import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sissan_donantes/services/blood_bank_service.dart';
import 'package:sissan_donantes/services/blood_bank_service_factory.dart';

import 'main.dart';

class StartPage extends StatefulWidget {
  final String country;
  final String medicalCenter;
  final String result = "";
  StartPage({Key key, @required this.country, this.medicalCenter})
      : super(key: key);
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
   String result = "";
  String resultImage = "";
  BloodBankService _service;
  Widget imageScan;

  @override
  void initState() {
    super.initState();
    if (widget.medicalCenter != "") {
      _service = BloodBankServiceFactory.getInstance().getService();
      getImage();
    }
  }

  getImage() async {
    _service
        .getImageScannedCollectionPoint(widget.medicalCenter)
        .then((onValue) async {
      final image = Image.memory(
        Base64Decoder().convert(onValue),
        fit: BoxFit.contain,
      );
      await precacheImage(image.image, context);
      setState(() {
        imageScan = image;
      });
    });
  }

  String selectImageByCountry() {
    switch (widget.country) {
      case "UY":
        {
          return "images/doymisangreuy.png";
        }
        break;
      case "AR":
        {
          return "images/doymisangrear.png";
        }
        break;
      case "PY":
        {
          return "images/doymisangrepy.png";
        }
        break;
      case "BO":
        {
          return "images/doymisangrebo.png";
        }
        break;
      default:
        return "images/doymisangre.png";
    }
  }

  void cameraPermissionDenied(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Permiso requerido."),
          content: Text(
              'Para poder escanear un código QR es necesario obtener permiso para utilizar la cámara del dispositivo.'),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  void conditions(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Términos de uso"),
          content: Text(
              'La utilización de DoyMiSangre es de uso gratuito para el usuario,quien se compromete a utilizarlo respetando la normativa nacional vigente.La información aquí vertida por el usuario será utilizada únicamente con los fines para los cuales fue aportada.'),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Future _scan() async {
    try {
      var qrResult = await BarcodeScanner.scan();
            //log.i(qrResult);
      setState(() {
        if (qrResult.rawContent.contains(
            new RegExp(r'https://doymisangre.com', caseSensitive: false))) {
          List<String> res = qrResult.rawContent.split('?');
          List<String> res2 = res[1].split(',');
          runApp(MyApp(
            flag: true,
            optionalBloodBankCode: res2[0],
            optionalCollectionPointCode: res2[1],
          ));
        } else {
          throw new Exception();
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        cameraPermissionDenied(context);
        setState(() {
          result = "";
        });
      } else {
        setState(() {
          result = "Unkown error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "";
      });
    } catch (e) {
      setState(() {
        result = "";
      });
    }
  }

  Widget qrScanned() {
    if (widget.medicalCenter != "") {
      if (imageScan != null) {
        return imageScan;
      } else {
        return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 4,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)));
      }
    } else {
      return new Column(children: <Widget>[
        Ink(
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.red),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.cameraRetro),
            color: Colors.white,
            onPressed: _scan,
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Escanear código QR',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
       
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Image.asset(
            selectImageByCountry(),
            width: 300,
            height: 300,
          )),
          Container(child: qrScanned()),
          Container(
            margin: EdgeInsets.only(top: 100.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: RichText(
                text: TextSpan(
                    text: 'Deslizá hacia la izquierda para comenzar.',
                    style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
              ),
            ),
          ),
          new Expanded(
              child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                       child: FlatButton(
                        onPressed: () {
                          conditions(context);
                        },
                        child: Text("Condiciones de uso",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                height: 5,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ))),
        ],
      ),
    );
  }
}
