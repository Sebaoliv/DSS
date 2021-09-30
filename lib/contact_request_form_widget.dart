import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sissan_donantes/end_page.dart';
import 'package:sissan_donantes/services/blood_bank_service.dart';
import 'package:sissan_donantes/services/blood_bank_service_factory.dart';
import 'package:sissan_donantes/validators/country_validator_picker.dart';
import 'package:sissan_donantes/validators/email_validator.dart';
import 'package:sissan_donantes/validators/required_validator.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'interfaces/ivalidator.dart';
import 'model/contact_request.dart';

class ContactRequestFormWidget extends StatefulWidget {
  final int jorColectaId;
  final String jorColectaNombre;
  final String countryCode;
  final int optionalAppointmentId;
  final DateTime optionalAppointmentDate;
  final String optionalHour;
  ContactRequestFormWidget(
      {Key key,
      @required this.jorColectaId,
      @required this.jorColectaNombre,
      @required this.countryCode,
      @required this.optionalAppointmentDate,
      @required this.optionalAppointmentId,
      this.optionalHour})
      : super(key: key);

  @override
  _ContactRequestFormWidgetState createState() =>
      _ContactRequestFormWidgetState(jorColectaId, jorColectaNombre, countryCode);
}

class _ContactRequestFormWidgetState extends State<ContactRequestFormWidget> {
  int jorColectaId;
  String jorColectaNombre;
  String countryCode;
  final _formKey = GlobalKey<FormState>();
 
  static const String DocumentKey = "Document";
  static const String NamesKey = "Names";
  static const String LastNamesKey = "LastNames";
  static const String BirthdateKey = "Birthdate";
  static const String PhoneNumberKey = "PhoneNumber";
  static const String EmailKey = "Email";

  ContactRequest _formResult;
  BloodBankService _service;
  Map<String, TextEditingController> _formFieldControllers = {};

  bool _isSendingRequest = false;

  _ContactRequestFormWidgetState(
      this.jorColectaId, this.jorColectaNombre, this.countryCode) {
    _formResult = new ContactRequest();
  }

  @override
  void initState() {
    super.initState();
    _service = BloodBankServiceFactory.getInstance().getService();
    initializeDateFormatting('es_ES');
    // _service.getGeoStates("UY").then((List<GeoState> states) {
    //   setState(() {
    //   });
    // });

    _generateController(DocumentKey);
    _generateController(NamesKey);
    _generateController(LastNamesKey);
    _generateController(BirthdateKey);
    _generateController(PhoneNumberKey);
    _generateController(EmailKey);
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(
      context,
    );
    pr.style(
        message: 'Procesando datos..',
        borderRadius: 2.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.bounceInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));
    return Scaffold(
        body: SafeArea(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/test.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                padding: EdgeInsets.only(top: 5.0),
                child:_buildCollectionPointName("Jornada seleccionada")),
                      Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: _buildSelectedDateField(widget.optionalAppointmentDate)),
                      Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: _buildSelectedTimeField(widget.optionalHour.toString())),
                       Padding(
               padding: EdgeInsets.all(15.0),
                child:_buildDocumentField()),
                       Padding(
               padding: EdgeInsets.all(15.0),
                child:_buildSimpleTextField("Nombres*", NamesKey,
                          validator: RequiredValidator())),
                       Padding(
               padding: EdgeInsets.all(15.0),
                child:_buildSimpleTextField("Apellidos*", LastNamesKey,
                          validator: RequiredValidator())),
                       Padding(
               padding: EdgeInsets.all(15.0),
                child:_buildBirthdateField(context)),
                       Padding(
               padding: EdgeInsets.all(15.0),
                child:_buildSimpleTextField(
                          "Número de Teléfono*", PhoneNumberKey,
                          validator: RequiredValidator())),
                       Padding(
                padding: EdgeInsets.all(15.0),
                child:_buildSimpleTextField("Correo Electrónico", EmailKey,
                          keyboardType: TextInputType.emailAddress,
                          validator: EmailValidator(required: false))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: _isSendingRequest
                              ? null
                              : () async {
                                  final form = _formKey.currentState;

                                  if (form.validate()) {
                                    await pr.show();
                                    setState(() {
                                      _isSendingRequest = true;
                                    });

                                    _assignFieldsToContactRequest();
                                    form.save();
                                    try {
                                      _service
                                          .sendContactRequest(_formResult)
                                          .whenComplete(() {
                                        setState(() {
                                          _isSendingRequest = true;
                                        });

                                        endProgressDialog(pr);
                                        _showSuccessDialog();
                                      });
                                    } catch (e) {}
                                  }
                                },
                          child: Text('Enviar datos de contacto'),
                          color: Colors.red[600],
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    ));
  }

  void _assignFieldsToContactRequest() {
    _formResult.documentNumber = _formFieldControllers[DocumentKey].text;
    _formResult.email = _formFieldControllers[EmailKey].text;
    _formResult.names = _formFieldControllers[NamesKey].text;
    _formResult.lastNames = _formFieldControllers[LastNamesKey].text;
    _formResult.phoneNumber = _formFieldControllers[PhoneNumberKey].text;
    _formResult.jorColectaId = widget.jorColectaId;
    _formResult.appointementId = widget.optionalAppointmentId;
    _formResult.collectionDate = widget.optionalAppointmentDate;
  }

  bool _checkIsAppointment() {
    if (widget.optionalHour != null && widget.optionalAppointmentDate != null) {
      return true;
    } else {
      return false;
    }
  }

  Visibility _buildSelectedTimeField(String hour) {
    Visibility field = Visibility(
        visible: _checkIsAppointment(),
        child: new TextFormField(
          decoration: InputDecoration(
             contentPadding: EdgeInsets.all(15.0),
              border: InputBorder.none,
          filled: true,
            labelText: "Hora seleccionada",
          ),
          readOnly: true,
          initialValue: hour,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ));
    return field;
  }

  Visibility _buildSelectedDateField(DateTime date) {
    if (date == null) {
      date = DateTime.now();
    }
    Visibility field = Visibility(
        visible: _checkIsAppointment(),
        child: new TextFormField(
          decoration: InputDecoration(
             contentPadding: EdgeInsets.all(15.0),
                border: InputBorder.none,
          filled: true,
            labelText: "Fecha seleccionada",
          ),
          readOnly: true,
          initialValue:
              DateFormat('EEEE d MMM yyyy', 'es_ES').format(date).toString(),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ));
    return field;
  }

  TextFormField _buildBirthdateField(BuildContext context) {
    TextFormField field = TextFormField(
      key: Key(BirthdateKey),
      decoration: const InputDecoration(
         contentPadding: EdgeInsets.all(15.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
           border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.blue)),
          filled: true,
        labelText: "Fecha de Nacimiento*",
      ),
      controller: _formFieldControllers[BirthdateKey],
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      onTap: () {
        var now = DateTime.now();
        var eighteenYearsAgo = now.subtract(Duration(days: 365 * 18));
        var seventyYearsAgo = now.subtract(Duration(days: 365 * 70));

        showDatePicker(
                context: context,
                initialDate: eighteenYearsAgo,
                firstDate: seventyYearsAgo,
                lastDate: eighteenYearsAgo,
                initialDatePickerMode: DatePickerMode.year)
            .then((DateTime birthDate) {
          _formResult.birthDate = birthDate;
          _formFieldControllers[BirthdateKey].text =
              DateFormat("dd/MM/yyyy").format(birthDate);
        });
      },
    );
    return field;
  }

  TextFormField _buildCollectionPointName(String labelText,
      {TextInputType keyboardType: TextInputType.text,
      IValidator<String> validator}) {
    return new TextFormField(
      decoration: InputDecoration(
           border: InputBorder.none,
          filled: true,
         contentPadding: EdgeInsets.all(15.0),
        labelText: labelText,
      ),
      readOnly: true,
      initialValue: jorColectaNombre,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  TextFormField _buildSimpleTextField(String labelText, String controlKey,
      {TextInputType keyboardType: TextInputType.text,
      IValidator<String> validator}) {
    return new TextFormField(
      //focusNode: _createValidatorFocusNode(),
      decoration: InputDecoration(
         floatingLabelBehavior: FloatingLabelBehavior.always,
           border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.blue)),
          filled: true,
        labelText: labelText,
      ),
      controller: _formFieldControllers[controlKey],
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      validator: validator.validate,
      keyboardType: keyboardType,
    );
  }

  TextFormField _buildDocumentField() {
    return TextFormField(
      key: Key(DocumentKey),
      
      decoration: const InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
           border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.blue)),
          filled: true,
         contentPadding: EdgeInsets.all(15.0),
        labelText: "Documento de identidad*",
        hintText: "Sin puntos ni guiones",
      ),
      controller: _formFieldControllers[DocumentKey],
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      validator: (String value) {
        if (value.trim().length == 0) {
          return "Debe ingresar su documento de identidad \nsin puntos ni guiones";
        }
        var validatorPicker = CountryValidatorPicker();
        var validator = validatorPicker.getDocumentValidatorForCountry(widget.countryCode);
        if (validator != null) {
          return validator.validate(value);
        } else {
          return null;
        }
      },
    );
  }

  void _generateController(String key) {
    _formFieldControllers.putIfAbsent(key, () => TextEditingController());
  }

  endProgressDialog(ProgressDialog pr) async {
    await pr.hide();
  }

  void _showSuccessDialog() {
    if (widget.optionalAppointmentId!=null && widget.optionalAppointmentDate!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => EndPage(type:"R")));
     }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => EndPage(type:"S")));
     }
    
  }
}
