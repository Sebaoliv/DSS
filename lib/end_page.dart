import 'package:flutter/material.dart';
import 'package:sissan_donantes/main.dart';

class EndPage extends StatefulWidget {
  final String type;
EndPage({Key key,@required this.type});

  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.type=="R")
         ? appointment()
         : request();
  }
Widget appointment(){
 return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            //backgroundColor: Colors.transparent,
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/test.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                                              child: Image.asset(
                      "images/Gracias.png",
                                    )),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
                        child: SizedBox(
                                 child: FittedBox(
                                child: Text(
                              "Tu solicitud fue recibida correctamente.",
                              //maxLines: 4,
                              style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),
                            )))),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
                        child: SizedBox(
                          height: 20,
                            child: FittedBox(
                                child: Text(
                              "A la brevedad recibirás un correo electrónico",
                              //maxLines: 4,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            )))),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
                        child: SizedBox(
                            height:18,
                            child: FittedBox(
                                child: Text(
                              "conteniendo toda la información",
                              // maxLines: 4,
                              style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),
                            )))),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                        child: SizedBox(
                            height: 18,
                            
                             child: FittedBox(
                                child: Text(
                              "acerca del lugar, día y hora",
                              // maxLines: 4,
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            )))),
                             Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                        child: SizedBox(
                             height: 18,
                            
                             child: FittedBox(
                                child: Text(
                              "de tu próxima donación de sangre.",
                              // maxLines: 4,
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            )))),
                    Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: SizedBox(
                            height: 15,
                            width: 350,
                            child: FittedBox(
                                child: Text(
                              "Vuelve al inicio para donar la próxima vez",
                              // maxLines: 4,
                              style: TextStyle(fontSize: 40),
                            )))),
                    SizedBox(
                        height: 15,
                        width: 400,
                        child: FittedBox(
                            child: Text(
                          "haciendo click en el botón debajo.",
                          // maxLines: 4,
                          style: TextStyle(fontSize: 40),
                        ))),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () => restartMyApp(),
                            child: Text('Volver al inicio'),
                            color: Colors.red[600],
                            textColor: Colors.white,
                          )),
                    )
                  ],
                ))));
}
 Widget request(){
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            //backgroundColor: Colors.transparent,
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/test.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                                              child: Image.asset(
                      "images/Gracias.png",
                                    )),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                        child: SizedBox(
                                 child: FittedBox(
                                child: Text(
                              "Tu solicitud fue recibida correctamente.",
                              //maxLines: 4,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            )))),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                        child: SizedBox(
                            height: 20,
                        width: 400,
                            child: FittedBox(
                                child: Text(
                              "A la brevedad nos pondremos en contacto contigo",
                              //maxLines: 4,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            )))),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                        child: SizedBox(
                            height: 18,
                            child: FittedBox(
                                child: Text(
                              "para que puedas agendar tu donación de sangre",
                              // maxLines: 4,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            )))),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                        child: SizedBox(
                            height:16,
                             child: FittedBox(
                                child: Text(
                              "en el día y hora de tu conveniencia.",
                              // maxLines: 4,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            )))),
                    Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: SizedBox(
                            height: 15,
                            width: 350,
                            child: FittedBox(
                                child: Text(
                              "Vuelve al inicio para donar la próxima vez",
                              // maxLines: 4,
                              style: TextStyle(fontSize: 40),
                            )))),
                    SizedBox(
                        height: 15,
                        width: 400,
                        child: FittedBox(
                            child: Text(
                          "haciendo click en el botón debajo.",
                          // maxLines: 4,
                          style: TextStyle(fontSize: 40),
                        ))),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () => restartMyApp(),
                            child: Text('Volver al inicio'),
                            color: Colors.red[600],
                            textColor: Colors.white,
                          )),
                    )
                  ],
                ))));
 }

  void restartMyApp() {
    runApp(new MyApp(
      flag: true,
      optionalBloodBankCode: "",
      optionalCollectionPointCode: "",
      key: UniqueKey(),
    ));
  }
}
