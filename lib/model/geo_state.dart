import 'package:sissan_donantes/interfaces/iidentifiable.dart';
import 'package:sissan_donantes/interfaces/inameable.dart';

class GeoState implements IIdentifiable, INameable {
  int id;
  String name;
    bool porDefecto;

  GeoState({this.id, this.name,this.porDefecto});

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;

    return id == other.id;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "${id.toString()} - $name";

  factory GeoState.fromJson(Map<String, dynamic> json){
    return new GeoState(id: json["DivisionPaisId"], name: json["DivisionPaisNombre"],porDefecto:json["DivisionPaisPorDefecto"]);
  }
}
