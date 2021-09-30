import 'package:sissan_donantes/interfaces/icountry_dependent_validator.dart';

class UruguayDocumentValidator implements ICountryDependentValidator<String> {
  @override
  String validate(String value) {
    if (_isValid(value)) return null;
    return "La cédula no es correcta. Verifique los dígitos.";
  }

  int _generateValidationDigit(String ci) {
    var a = 0;
    var i = 0;
    if (ci.length <= 6) {
      for (i = ci.length; i < 7; i++) {
        ci = '0' + ci;
      }
    }
    for (i = 0; i < 7; i++) {
      a += (int.parse("2987634"[i]) * int.parse(ci[i])) % 10;
    }

    if (a % 10 == 0) {
      return 0;
    } else {
      return 10 - a % 10;
    }
  }

  bool _isValid(String ci) {
    ci = _cleanCI(ci);
    var dig = ci[ci.length - 1];
    ci = ci.replaceAll(new RegExp(r"[0-9]$"), '');
    return (int.parse(dig) == _generateValidationDigit(ci));
  }

  String _cleanCI(ci) {
    return ci.replaceAll(
        new RegExp(
          r"\D",
        ),
        '');
  }

  @override
  String getCountry() {
    return "UY";
  }
}
