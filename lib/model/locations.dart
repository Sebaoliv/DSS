import 'package:sissan_donantes/interfaces/iidentifiable.dart';
import 'package:sissan_donantes/interfaces/inameable.dart';

class Location implements IIdentifiable, INameable {
  int id;
  String name;
  int divIdPais;


  Location({this.id, this.name,this.divIdPais});

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;

    return id == other.id && divIdPais==other.divIdPais;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "${id.toString()} - $name";

  factory Location.fromJson(Map<String, dynamic> json){
    return new Location(id: json["LocalidadId"], name: json["LocalidadNombre"], divIdPais: json["LocalidadDivPaisId"]);
  }
}