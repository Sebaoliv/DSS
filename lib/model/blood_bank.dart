import 'package:sissan_donantes/interfaces/iidentifiable.dart';
import 'package:sissan_donantes/interfaces/inameable.dart';

class BloodBank implements IIdentifiable, INameable {
  int id;
  String name;
  int stateId;

  BloodBank({this.id, this.name, this.stateId});

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    return id == other.id;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "$id - $name";

  factory BloodBank.fromJson(Map<String, dynamic> json) {
    return BloodBank(id: json["BancoSangreId"], name: json["BancoSangreNombre"], stateId: json["BancoSangreDivPaisId"]);
  }
}
