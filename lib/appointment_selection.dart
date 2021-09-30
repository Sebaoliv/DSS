import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sissan_donantes/contact_request_form_widget.dart';
import 'package:sissan_donantes/model/appointment.dart';
import 'package:sissan_donantes/model/collection_day.dart';
import 'package:sissan_donantes/services/blood_bank_service.dart';
import 'package:sissan_donantes/services/blood_bank_service_factory.dart';
import 'package:sissan_donantes/styles.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentSelectionWidget extends StatefulWidget {
  final String collectionPointDescription;
  final int jorColectaId;
  final bool useBackground;
  final String country;
  AppointmentSelectionWidget(
      {Key key,
      @required this.collectionPointDescription,
      this.jorColectaId,
      this.useBackground,
      this.country})
      : super(key: key);

  @override
  _AppointmentSelectionWidgetState createState() =>
      _AppointmentSelectionWidgetState();
}

class _AppointmentSelectionWidgetState
    extends State<AppointmentSelectionWidget> {
  BloodBankService _service;
  List<String> _dates;
  Future<CollectionDay> _collectionDay;
  List<Appointment> _appSource = new List<Appointment>();
  String _selectedAppointment;
  String _selectedDate;
  List<Appointment> appointments;

  @override
  void initState() {
    super.initState();
    appointments = new List<Appointment>();
    initializeDateFormatting('es_ES');
    _service = BloodBankServiceFactory.getInstance().getService();
  
    getCollectionDayData();
       }

void checkIfSingleDate(BuildContext context){
   if (_dates.length==1&&_dates!=null){
     setState(() {
     _selectedDate=_dates[0];  
      _appSource = appointments
                .where((Appointment ap) => ap.date == _selectedDate)
                .toList();
     });
     
   }
 }
  void _filterAppointmentDays() {
    _dates = new List<String>();
    for (Appointment ap in appointments) {
      if (!_dates.contains(ap.date)) {
        _dates.add(ap.date);
      }
    }
     
  }

  Decoration checkBackground() {
    if (widget.useBackground) {
      return BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/test.png"),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return new BoxDecoration();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return new FutureBuilder(
        future: _collectionDay,
        builder: (context, data) {
          if (data.hasData) {
            appointments = _service.collectionDay.appointments;
            _filterAppointmentDays();
            WidgetsBinding.instance.addPostFrameCallback((_) => checkIfSingleDate(context));
                 return Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    decoration: checkBackground(),
                    child: Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Form(
                            child: Column(children: <Widget>[
                          _buildText(
                              'Selecciona un día y horario de tu conveniencia.'),
                          _buildSelectedCenterText(
                              widget.collectionPointDescription),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: _buildDaysDropDown(_dates),
                          ),
                          _buildAvailableHoursText('Horarios disponibles'),
                          new Expanded(
                            child: Wrap(
                            spacing: 5,
                            children: _appSource.map((appoint) {
                              return ChoiceChip(
                                label: Text(appoint.hour),
                                backgroundColor: Colors.lightGreen,
                                selected: _selectedAppointment == appoint.hour,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedAppointment = appoint.hour;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ContactRequestFormWidget(
                                                  jorColectaId:
                                                      widget.jorColectaId,
                                                  jorColectaNombre: widget
                                                      .collectionPointDescription,
                                                  countryCode: widget.country,
                                                  optionalAppointmentDate:
                                                      DateTime.parse(
                                                          appoint.date),
                                                  optionalAppointmentId:
                                                      appoint.id,
                                                  optionalHour: appoint.hour,
                                                  
                                                )));
                                  });
                                },
                                selectedColor: Colors.lightGreen,
                              );
                            }).toList(),
                          ))
                        ])),
                      ),
                    ])));
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
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.red))),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
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
          }
        });
  }

  static ListTile _buildAvailableHoursText(String text,
          {TextStyle style: Styles.bold}) =>
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.clock,
          color: Colors.red,
        ),
        title: Text(text,
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            )),
        contentPadding: EdgeInsets.symmetric(horizontal: 45.0),
      );

  static ListTile _buildText(String text, {TextStyle style: Styles.bold}) =>
      ListTile(
        //leading:FaIcon(FontAwesomeIcons.aws),
        title: Text(text,
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            )),
      );

  static ListTile _buildSelectedCenterText(String text,
          {TextStyle style: Styles.bold}) =>
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.check,
          color: Colors.red,
        ),
        title: Text(text,
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            )),
      );

  String _getDayofTheWeek(String date) {
    DateTime dt = DateTime.parse(date);
    var test = DateFormat('EEEE d MMM yyyy', 'es_ES').format(dt);
    return test.toString();
  }

  DropdownButtonFormField<String> _buildDaysDropDown(List<String> items) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
              value: item, child: Text(_getDayofTheWeek(item)));
        }).toList(),
        onChanged: (String value) {
          setState(() {
            _selectedDate = value;
            _appSource = appointments
                .where((Appointment ap) => ap.date == value.toString())
                .toList();
          });
        },
        value: _selectedDate,
        hint: Text(
          "Seleccione una fecha",
          style: GoogleFonts.robotoCondensed(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ));
  }

  getCollectionDayData() {
    setState(() {
      _collectionDay = _service.getCollectionDay(widget.jorColectaId);
    });
  }
}
