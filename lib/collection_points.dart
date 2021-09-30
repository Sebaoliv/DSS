import 'package:flutter/material.dart';
import 'package:sissan_donantes/appointment_selection.dart';
import 'package:sissan_donantes/contact_request_form_widget.dart';
import 'package:sissan_donantes/model/collection_point.dart';
import 'package:sissan_donantes/model/locations.dart';
import 'package:sissan_donantes/services/blood_bank_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model/geo_state.dart';

class CollectionPointsWidget extends StatefulWidget {
  final String country;

  CollectionPointsWidget({Key key, @required this.country}) : super(key: key);

  @override
  _CollectionPointsWidgetState createState() =>
      _CollectionPointsWidgetState(country);
}

class _CollectionPointsWidgetState extends State<CollectionPointsWidget> {
  String country;
  BloodBankService service;
  Location _selectedLocation;
  GeoState _selectedState;
  //BloodBank _noPreference;
  List<GeoState> _geoStates = [];
  List<Location> _availableLocations = [];
  List<Location> _availableLocationsSource = [];

  List<CollectionPoint> _collectionPoints = [];

  List<CollectionPoint> _collectionPointsSource = [];

  _CollectionPointsWidgetState(this.country) {
    _selectedState = null;
    _selectedLocation = null;
  }

  @override
  void initState() {
    super.initState();
    service = BloodBankService();
    service.getGeoStates(country).then((List<GeoState> states) {
      setState(() {
        _geoStates = states;
        service.getLocations(country).then((List<Location> locs) {
          _availableLocations = locs;
        });
        service
            .getCollectionPoints(country)
            .then((List<CollectionPoint> colPoints) {
          _collectionPoints = colPoints;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: RichText(
                  text: TextSpan(
                      text:
                          'Selecciona un punto de colecta de tu conveniencia.',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      )),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Form(
                child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: _buildGeoStateDropDown(_geoStates),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: _buildLocationsDropDown(_availableLocationsSource),
              ),
              new Expanded(
                  child: _buildCollectionPointsList(_collectionPointsSource)),
                  Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.transparent,  
                    borderRadius: BorderRadius.circular(10))),
            ])),
          ),
        ]));
  }

  DropdownButtonFormField<GeoState> _buildGeoStateDropDown(
      List<GeoState> items) {
    return DropdownButtonFormField<GeoState>(
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
        items: items.map<DropdownMenuItem<GeoState>>((GeoState item) {
          return DropdownMenuItem<GeoState>(
              value: item,
              child: Text(
                item.name,
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ));
        }).toList(),
        onChanged: (GeoState value) {
          setState(() {
            _selectedState = value;
            _availableLocationsSource = _availableLocations
                .where((Location lc) => lc.divIdPais == value.id)
                .toList();
            _availableLocationsSource.insert(
                0, new Location(divIdPais: 0, id: 0, name: "Todas"));
            _collectionPointsSource = _collectionPoints
                .where((CollectionPoint col) =>
                    col.jorColectaPtoColectaDivPaisId == value.id)
                .toList();
            _selectedLocation = _availableLocationsSource[0];
          });
        },
        value: _selectedState,
        hint: Text("Elija el Departamento/ciudad",
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 20,
              ),
            )));
  }

  DropdownButtonFormField<Location> _buildLocationsDropDown(
      List<Location> items) {
    return DropdownButtonFormField<Location>(
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
      items: items.map<DropdownMenuItem<Location>>((Location item) {
        return DropdownMenuItem<Location>(
            value: item,
            child: Text(
              item.name,
              style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ));
      }).toList(),
      onChanged: (Location value) {
        setState(() {
          _collectionPointsSource = _collectionPoints
              .where((CollectionPoint col) =>
                  (value.id == 0 ||
                      col.jorColectaPtoColectaLocalId == value.id) &&
                  col.jorColectaPtoColectaDivPaisId == _selectedState.id)
              .toList();
          _selectedLocation = value;
        });
      },
      value: _selectedLocation,
      hint: Text(
        "Elija la localidad.",
        style: GoogleFonts.robotoCondensed(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionPointsList(List<CollectionPoint> colPoints) {
    return ListView(
      children: colPoints.map((data) => _collectionPointItem(data)).toList(),
    );
  }

  ListTile _collectionPointItem(CollectionPoint data) {
    if (data.fechaJornada.trim() == "JORNADA FIJA") {
      if (data.jorColectaAgeHabDte == "S") {
        return ListTile(
            leading: Icon(Icons.business),
            title: Text(
              data.name,
              style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            subtitle: Text(
              "Dirección:" +
                  data.direccion +
                  " \nHorarios:" +
                  data.horarios +
                  "\nInfo.adicional:" +
                  data.informacionAdicional,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AppointmentSelectionWidget(
                          collectionPointDescription: data.organizador,
                          jorColectaId: data.jorColectaId,
                          useBackground: true,
                          country:country,
                        ))));
      } else {
        return ListTile(
            leading: Icon(Icons.business),
            title: Text(data.name,
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )),
            subtitle: Text(
              "Dirección:" +
                  data.direccion +
                  " \nHorarios:" +
                  data.horarios +
                  "\nInfo.adicional:" +
                  data.informacionAdicional,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ContactRequestFormWidget(
                          jorColectaId: data.jorColectaId,
                          jorColectaNombre: data.name,
                          countryCode: country,
                          optionalAppointmentDate: null,
                          optionalAppointmentId: null,
                        ))));
      }
    } else {
      if (data.jorColectaAgeHabDte == "S") {
        return ListTile(
            leading: Icon(Icons.business),
            title: Text(data.name,
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )),
            subtitle: Text(
              "Dirección:" +
                  data.direccion +
                  " \nHorarios:" +
                  data.horarios +
                  "\nInfo.adicional:" +
                  data.informacionAdicional,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AppointmentSelectionWidget(
                          collectionPointDescription: data.organizador,
                          jorColectaId: data.jorColectaId,
                          useBackground: true,
                           country: country,
                        ))));
      } else {
        return ListTile(
            leading: Icon(Icons.business),
            title: Text(
              data.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(
              TextSpan(
                  text: "Dirección:" +
                      data.direccion +
                      " \nHorarios:" +
                      data.horarios +
                      "\nInfo.adicional:" +
                      data.informacionAdicional +
                      "\n",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: data.fechaJornada.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    TextSpan(
                        text: "\nOrganiza:" + data.organizador,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ]),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ContactRequestFormWidget(
                          jorColectaId: data.jorColectaId,
                          jorColectaNombre: data.name,
                          countryCode: country,
                          optionalAppointmentDate: null,
                          optionalAppointmentId: null,
                        ))));
      }
    }
  }
}
