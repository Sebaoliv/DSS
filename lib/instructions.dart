import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'styles.dart';



class InstructionsWidget extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<InstructionsWidget>{

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        backgroundColor: Colors.transparent,
          body: Column(children:<Widget>[Expanded(
            child : ListView(children: [
            _headingTile(
                "Condiciones para donar sangre."),
            _headingTile2("Si reunes las siguientes condiciones puedes donar:"),
            _textTile(_buildAgeRestrictionItem(), null),
            _textTile(_buildWeightRestrictionItem(), null),
            _textTile(_buildDocumentItem(), null),
            _textTile(_buildFastingRestrictions(),null),
            _textTile(_buildHealthRestrictionsItem(), null),
            Divider(),
            _headingTile(
                "En caso de estar en alguna de estas situaciones, es mejor que NO dones en este momento:"),
            _textTile(_buildColdItem(), null),
            _textTile(_buildTattooPiercingItem(), null),
            _textTile(_buildHepatitisItem(), null),
            _textTile(_buildMedicationItem(), "Si es el caso no suspenderla, ya que puede ser perjudicial para tu salud."),
            _textTile(_linkToMedicalConditions(),null),
          ]
      )), Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.transparent,  
                    borderRadius: BorderRadius.circular(10)))]
            
        
    ));
    
  }
  static ListTile _headingTile(String text, {TextStyle style: Styles.bold}) => ListTile(
        title: Text(text, style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 22, ),)),
      );

  static ListTile _headingTile2(String text, {TextStyle style: Styles.bold}) => ListTile(
        title: Text(text, style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize:20, ),)),
      );

  static ListTile _textTile(Text text, String subtitle,
      {IconData icon: FontAwesomeIcons.tint}) {
    return ListTile(
        title: text,
        subtitle: subtitle == null ? null : Text(subtitle,style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12, ),),),
        leading: FaIcon(icon, color: Styles.red));
  }

  static Text _buildAgeRestrictionItem() => Text.rich(
          TextSpan(text: "Tener entre ", style:  GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(text: "18", style:  GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: " y ", style:  GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: "65", style:  GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: " años.", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))
      ]));

  static Text _buildWeightRestrictionItem() => Text.rich(
          TextSpan(text: "Pesar más de ", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(
          text: "50",
          style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),),
        ),
        TextSpan(text: " kilos.", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))
      ]));

  static Text _buildDocumentItem() =>
      Text.rich(TextSpan(text: "Tener ", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(
          text: "Documento de identidad",
          style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),),
        ),
        TextSpan(text: " vigente y en buen estado.", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))
      ]));

  static Text _buildFastingRestrictions() =>
      Text.rich(TextSpan(text: "Tener un ", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(
          text: "ayuno de sólidos de ",
          style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),),
        ),
        TextSpan(text: "no más de 4 horas.", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))

      ]));

  static Text _buildHealthRestrictionsItem() =>
      Text.rich(TextSpan(text: "Tener ", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(text: "buen estado", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: " de salud.", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))
      ]));

  static Text _buildColdItem() => Text.rich(TextSpan(
      text: "Si tienes síntomas de ",
      style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),),
             children: <TextSpan>[TextSpan(text: "gripe o resfrío.", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))]));

  static Text _buildTattooPiercingItem() => Text.rich(

        TextSpan(text: "Si te hiciste recientemente un ", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(text: "tatuaje", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: " o te has puesto un ", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: "piercing", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))
      ]));

  static Text _buildHepatitisItem() => Text.rich(
          TextSpan(text: "Has tenido ", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(text: "hepatitis", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: " después de los 12 años.", style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),))
      ]));

  static Text _buildMedicationItem() => Text.rich(
          TextSpan(text: "Estás tomando ",style:GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black,fontSize: 18, ),), children: <TextSpan>[
        TextSpan(text: "algún tipo de medicación", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18, ),)),
        TextSpan(text: ".", style: GoogleFonts.roboto(textStyle:TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black,fontSize: 18, ),))
      ]));

      
  static Text _linkToMedicalConditions() => Text.rich(
          TextSpan(
                style: new TextStyle(color:Colors.blue),
                text: 'Más información',
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final url = 'https://www.who.int/es/news-room/campaigns/world-blood-donor-day/2020/who-can-give-blood';
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: false,
                      );
                    }
                  },
              )
         );
         
}