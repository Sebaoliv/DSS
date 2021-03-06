import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'styles.dart';

class InstructionsBuilder {
  static ListView build() => ListView(children: [
        _headingTile("LEE ATENTAMENTE CADA UNO DE LOS PUNTOS."),
        _headingTile("Si reunes las siguientes condiciones puedes donar:"),
        _textTile(_buildAgeRestrictionItem(), null),
        _textTile(_buildWeightRestrictionItem(), null),
        _textTile(_buildDocumentItem(), null),
        _textTile(_buildFastingRestrictions(), ""),
        _textTile(_buildHealthRestrictionsItem(), null),
        Divider(),
        _headingTile(
            "En caso de estar en alguna de estas situaciones, es mejor que NO dones en este momento:"),
        _textTile(_buildColdItem(), null),
        _textTile(_buildTattooPiercingItem(), null),
        _textTile(_buildHepatitisItem(), null),
        _textTile(_buildMedicationItem(), ""),
      ]);

  static ListTile _headingTile(String text, {TextStyle style: Styles.bold}) =>
      ListTile(
        title: Text(text,
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            )),
      );

  static ListTile _textTile(Text text, String subtitle,
      {IconData icon: FontAwesomeIcons.tint}) {
    return ListTile(
        title: text,
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
        leading: FaIcon(icon, color: Styles.red));
  }

  static Text _buildAgeRestrictionItem() => Text.rich(TextSpan(
          text: "Tener entre ",
          style: GoogleFonts.robotoCondensed(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          children: <TextSpan>[
            TextSpan(
                text: "18",
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )),
            TextSpan(
                text: " y ",
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )),
            TextSpan(
                text: "65",
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )),
            TextSpan(
                text: " a??os.",
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ))
          ]));

  static Text _buildWeightRestrictionItem() => Text.rich(TextSpan(
          text: "Pesar m??s de ",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(
              text: "50",
              style: Styles.emphasis,
            ),
            TextSpan(text: " kilos.", style: Styles.bold)
          ]));

  static Text _buildDocumentItem() => Text.rich(TextSpan(
          text: "Tener la ",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(
              text: "C??dula de Identidad",
              style: Styles.bold,
            ),
            TextSpan(text: " vigente y en buen estado.", style: Styles.normal)
          ]));

  static Text _buildFastingRestrictions() => Text.rich(TextSpan(
          text: "Tener un ",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(
              text: "ayuno de s??lidos de ",
              style: Styles.bold,
            ),
            TextSpan(text: "no m??s de 4 horas.", style: Styles.emphasis)
          ]));

  static Text _buildHealthRestrictionsItem() => Text.rich(
          TextSpan(text: "Tener ", style: Styles.normal, children: <TextSpan>[
        TextSpan(text: "buen estado", style: Styles.bold),
        TextSpan(text: " de salud.", style: Styles.normal)
      ]));

  static Text _buildColdItem() => Text.rich(TextSpan(
          text: "	Si tienes s??ntomas de",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(text: "gripe o resfr??o.", style: Styles.bold)
          ]));

  static Text _buildTattooPiercingItem() => Text.rich(TextSpan(
          text: "Si te hiciste recientemente un ",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(text: "tatuaje", style: Styles.bold),
            TextSpan(text: " o te has puesto un ", style: Styles.normal),
            TextSpan(text: "piercing", style: Styles.bold)
          ]));

  static Text _buildHepatitisItem() => Text.rich(TextSpan(
          text: "Has tenido ",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(text: "hepatitis", style: Styles.bold),
            TextSpan(text: " despu??s de los 12 a??os.", style: Styles.normal)
          ]));

  static Text _buildMedicationItem() => Text.rich(TextSpan(
          text: "Est??s tomando ",
          style: Styles.normal,
          children: <TextSpan>[
            TextSpan(text: "alg??n tipo de medicaci??n", style: Styles.bold),
            TextSpan(text: ".", style: Styles.normal)
          ]));
}
