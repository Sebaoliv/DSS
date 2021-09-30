import 'package:sissan_donantes/interfaces/iidentifiable.dart';
import 'package:sissan_donantes/interfaces/inameable.dart';

class CollectionPoint implements IIdentifiable, INameable {
  int jorColectaId;
  String organizador;
  String fechaJornada;
  String name;
  String direccion;
  String informacionAdicional;
  String horarios;
  int jorColectaPtoColectaLocalId;
  int jorColectaPtoColectaDivPaisId;
  String jorColectaAgeHabDte;


  CollectionPoint({this.jorColectaId, this.organizador,this.fechaJornada,this.name,this.direccion,this.informacionAdicional,this.horarios,this.jorColectaPtoColectaLocalId ,this.jorColectaPtoColectaDivPaisId,this.jorColectaAgeHabDte});

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;

    return jorColectaId == other.jorColectaId;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "${jorColectaId.toString()} - $name";

  factory CollectionPoint.fromJson(Map<String, dynamic> json){
    return new CollectionPoint(jorColectaId: json["JorColectaId"], organizador: json["Organizador"],fechaJornada: json["FechaJornada"],name: json["PuntoDeColecta"],direccion: json["Direccion"],informacionAdicional: json["InformacionAdicional"],horarios: json["Horarios"],jorColectaPtoColectaLocalId:json["JorColectaPtoColectaLocalId"],jorColectaPtoColectaDivPaisId:json["JorColectaPtoColectaDivPaisId"],jorColectaAgeHabDte: json["JorColectaAgeHabDte"]);
  }

  @override
  int id;

}
