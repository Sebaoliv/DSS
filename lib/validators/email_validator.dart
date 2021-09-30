import 'package:sissan_donantes/interfaces/ivalidator.dart';
import 'package:sissan_donantes/validators/required_validator.dart';
import 'package:email_validator/email_validator.dart' as EmailAlgorithm;

class EmailValidator implements IValidator<String> {
  bool required = false;

  EmailValidator({this.required = false});

  @override
  String validate(String value) {
    if (required && (value == null || value.trim().isEmpty)) {
      return RequiredValidator().validate(null);
    }
    if (EmailAlgorithm.EmailValidator.validate(value)) {
      return null;
    }

    return "Formato de Email inválido. abc@xyz.com";
  }
}
