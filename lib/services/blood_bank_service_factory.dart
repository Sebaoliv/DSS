import 'package:sissan_donantes/services/blood_bank_service.dart';

class BloodBankServiceFactory{
  static BloodBankServiceFactory _factoryInstance;

  BloodBankService _service;

  BloodBankServiceFactory._private(){
    _service = new BloodBankService();
  }

  static BloodBankServiceFactory getInstance(){
    if(_factoryInstance == null){
      _factoryInstance = BloodBankServiceFactory._private();
    }

    return _factoryInstance;
  }

  BloodBankService getService(){
    return _service;
  }
}