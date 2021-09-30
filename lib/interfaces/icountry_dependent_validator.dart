import 'ivalidator.dart';

abstract class ICountryDependentValidator<T> implements IValidator<T>{
  String getCountry();
}