// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:developer';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sissan_donantes/model/contact_request.dart';

import 'package:sissan_donantes/services/blood_bank_service.dart';

void main() {
  setUp(() {
  });

  tearDown(() {
  });

  test('Test fetch geostate data', () async {
    HttpOverrides.global = null;
    // Build our app and trigger a frame.
    var service = BloodBankService();
    try {
      var geoStates = await service.getGeoStates("UY");
      print(geoStates);
      expect(true, geoStates.length > 0);
    } catch (e) {
      log(e);
    }
  });

  test('Test fetch blood bank data', () async {
    HttpOverrides.global = null;
    // Build our app and trigger a frame.
    var service = BloodBankService();
    try {
      // var bloodBanks = await service.getBloodBanks();
      var bloodBanks;
      print(bloodBanks);
      expect(true, bloodBanks.length > 0);
    } catch (e) {
      log(e);
    }
  });

  test('Post Contact Request', () async {
    HttpOverrides.global = null;
    var service = BloodBankService();
    var cr = ContactRequest();
    cr.birthDate = DateTime.parse("1989-04-18");
    //cr.bloodBankId = 2;
    cr.documentNumber = "41757787";
    cr.email = "rs@kinamic.com";
    //cr.geoStateId = 1;
    cr.lastNames = "SZYFER SABATH";
    cr.names = "RICARDO SAMUEL";
    cr.phoneNumber = "099622916";

    try {
      await service.sendContactRequest(cr);
    } catch (e) {
      log(e);
    }
  });

  test('Get Countries', () async {
    HttpOverrides.global = null;
    var service = BloodBankService();
    await service.loadCountry();
  });

  test('DateTime formats', () {
    print(DateTime.now().toIso8601String());
  });
}
