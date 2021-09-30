import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sissan_donantes/model/collection_day.dart';
import 'package:sissan_donantes/model/collection_point.dart';
import 'package:sissan_donantes/model/contact_request.dart';
import 'package:sissan_donantes/model/geo_state.dart';
import 'package:sissan_donantes/model/locations.dart';
import 'package:sissan_donantes/services/base_service.dart';

import 'package:sissan_donantes/utilities/logger.dart' as logger;

class BloodBankService extends BaseService {
  String _baseUrl = "https://doymisangre.com/rest/";
  Placemark _country;
  Map<String, String> _availableCountries = {};
  List<GeoState> _geoStates = [];
  List<CollectionPoint> _collectionPoints = [];
  List<Location> _locations = [];
  CollectionDay collectionDay;

  Future<List<GeoState>> getGeoStates(String country) async {
    var url =
        "https://doymisangre.com/rest/apidivisionespais?PaisId=" + country;

    if (_geoStates.isEmpty) {
      logger.info("Fetching GeoStates from server");
      try {
        var result = await get(url);
        var geoStates = json.decode(result);
        for (var geoState in geoStates) {
          _geoStates.add(GeoState.fromJson(geoState));
        }
      } catch (e) {
        logger.error(e.toString());
      }
    }
    return _geoStates;
  }

  Future<List<Location>> getLocations(String divpaisid) async {
    var url = _baseUrl + "apilocalidades?PaisId=" + divpaisid;
    _locations = new List<Location>();
    logger.info("Fetching GeoStates from server");
    try {
      var result = await get(url);
      var locations = json.decode(result);
      for (var location in locations) {
        _locations.add(Location.fromJson(location));
      }
    } catch (e) {
      logger.error(e.toString());
    }

    return _locations;
  }

  Future<String> getJorColectaId(
      String medicalcenter, String collectionPointCode) async {
    var url = _baseUrl +
        'apijorcolectaid?BancoSangreCodigo=' +
        medicalcenter +
        '&JorColectaCodigo=' +
        collectionPointCode;
    try {
      var result = await get(url);
      var jorcolectaid = json.decode(result);

      return jorcolectaid["JorColectaId"].toString();
    } catch (e) {
      return "";
    }
  }

  Future<CollectionDay> getCollectionDay(int jorColectaId) async {
    var url = _baseUrl + "apiDisponibilidadJornadas";
    var data = {"JorColectaId": jorColectaId};
    try {
      var res1 = await postJsonStr(url, data);
      var res2 = res1.toString();
      var resFormat = res2.substring(30, res2.length - 2);
      final resultPost = json.decode(resFormat);
      collectionDay = CollectionDay.fromJson(resultPost);
    } catch (e) {
      print(e);
    }
    return collectionDay;
  }

  Future<String> getImageScannedCollectionPoint(String code) async {
    var url = _baseUrl + "apilogo?BancoSangreCodigo=" + code;
    try {
      var result = await get(url);
      var imageCode = json.decode(result);
      return imageCode["Logo"].toString();
    } catch (e) {
      return null;
    }
  }

  Future<List<CollectionPoint>> getCollectionPoints(String pais) async {
    DateTime date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var dateToday =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(date.toString()));

    var url = _baseUrl +
        "apijornadasdisponibles?Hoy=" +
        dateToday.toString() +
        "&PaisId=" +
        pais;

    if (_collectionPoints.isEmpty) {
      logger.info("Fetching Blood Banks from server");
      try {
        var result = await get(url);
        var collectionPoints = json.decode(result);

        for (var colPoint in collectionPoints) {
          _collectionPoints.add(CollectionPoint.fromJson(colPoint));
        }

        _collectionPoints.sort((a, b) => a.name.compareTo(b.name));
      } catch (e) {
        logger.error(e.toString());
      }
    }
    return _collectionPoints;
  }

  Future loadCountry() async {
    //var url = "$_baseUrl/rest/apipaises";
    var url = _baseUrl + "apipaises";

    if (_country == null) {
      try {
        var contents = await get(url);
        final countries = jsonDecode(contents);
        for (var country in countries) {
          _availableCountries.putIfAbsent(
              country["PaisId"].toString().toLowerCase(),
              () => country["PaisNombre"].toString().toLowerCase());
        }

        var geolocator = new Geolocator();
        final position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            locationPermissionLevel: GeolocationPermission.location);

        List<Placemark> p = await geolocator.placemarkFromCoordinates(
            position.latitude, position.longitude);

        _country = p[0];
      } catch (e) {
        logger.error(e);
      }
    }
  }

  Future sendContactRequest(ContactRequest formResult) async {
    var url = _baseUrl + "apiInsertarSolicitudContacto";
    var completer = new Completer();
    var requestBody;
    if (formResult.appointementId != null &&
        formResult.collectionDate != null) {
      requestBody = {
        "SDTSolicitudContacto": {
          "SolicitudCtoId": "0",
          "SolicitudCtoFechaHora": DateTime.now().toIso8601String(),
          "SolicitudCtoDocIdentidad": formResult.documentNumber,
          "SolicitudCtoApellidos": formResult.lastNames,
          "SolicitudCtoNombres": formResult.names,
          "SolicitudCtoFechaNac":
              DateFormat("yyyy-MM-dd").format(formResult.birthDate),
          "SolicitudCtoNroMovil": formResult.phoneNumber,
          "SolicitudCtoEMail": formResult.email,
          "SolicitudCtoJorColectaId": formResult.jorColectaId,
          "SolicitudCtoResFecha":
              DateFormat("yyyy-MM-dd").format(formResult.collectionDate),
          "SolicitudCtoResTurnoId": formResult.appointementId
        }
      };
    } else {
      requestBody = {
        "SDTSolicitudContacto": {
          "SolicitudCtoId": "0",
          "SolicitudCtoFechaHora": DateTime.now().toIso8601String(),
          "SolicitudCtoDocIdentidad": formResult.documentNumber,
          "SolicitudCtoApellidos": formResult.lastNames,
          "SolicitudCtoNombres": formResult.names,
          "SolicitudCtoFechaNac":
              DateFormat("yyyy-MM-dd").format(formResult.birthDate),
          "SolicitudCtoNroMovil": formResult.phoneNumber,
          "SolicitudCtoEMail": formResult.email,
          "SolicitudCtoJorColectaId": formResult.jorColectaId,
        }
      };
    }

    try {
      postJson(url, requestBody).then((result) {
        var resultId = result["SolicitudCtoId"];
        if (int.tryParse(resultId) == 0) {
          //if (resultId == null || resultId <= 0)  {
          completer.completeError(
              "El servidor no procesó correctamente al contacto");
        } else {
          completer.complete();
        }
      });
    } catch (e) {
      print(e);
    }

    return completer.future;
  }

  Future<String> getCountry() async {
    switch (_country.country) {
      case "Uruguay":
        {
          return "UY";
        }
        break;
      case "Argentina":
        {
          return "AR";
        }
        break;
      case "Paraguay":
        {
          return "PY";
        }
        break;
      case "Bolivia":
        {
          return "BO";
        }
        break;
      default:
        return "";
    }
  }

  List<Location> getLocationsList() {
    return _locations;
  }
}
