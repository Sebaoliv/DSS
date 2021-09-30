import 'package:sissan_donantes/interfaces/iidentifiable.dart';
//import 'package:sissan_donantes/interfaces/inameable.dart';

class Appointment implements IIdentifiable{
  String date;
  int id;
  String hour;

  Appointment({this.id, this.date,this.hour});

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    return id == other.id;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "${id.toString()} - $hour -$date";

  factory Appointment.fromJson(Map<String, dynamic> json){
    return new Appointment(id: json["TurnoId"], date: json["Fecha"],hour:json["TurnoHora"]);
  }

}
