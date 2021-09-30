import 'package:sissan_donantes/interfaces/icountry_dependent_validator.dart';
import 'package:sissan_donantes/interfaces/ivalidator.dart';
import 'package:sissan_donantes/validators/uruguay_document_validator.dart';

class CountryValidatorPicker {
  List<ICountryDependentValidator<String>> _documentValidators = [new UruguayDocumentValidator()];
  CountryValidatorPicker();

  IValidator<String> getDocumentValidatorForCountry(String country) {
    var validator = _documentValidators.firstWhere((validator) => validator.getCountry().toLowerCase() == country?.toLowerCase(), orElse: () => null);
    return validator;
  }
}
