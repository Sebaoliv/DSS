import 'package:sissan_donantes/model/appointment.dart';
import 'package:sissan_donantes/interfaces/iidentifiable.dart';

class CollectionDay implements IIdentifiable{
   int id;
  String description;
  String date;
  bool permanent;
  String availableAgenda;
  List<Appointment>appointments;

  CollectionDay({this.id,this.description,this.date,this.permanent,this.availableAgenda,this.appointments});

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;

    return id == other.id;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => "${id.toString()} -$description";


  CollectionDay.fromJson(Map<String, dynamic> json) {
    id = json['JorColectaId'];
    description = json['JorColectaPtoColectaDescripcion'];
    permanent = json['JorColectaPermanente'];
    date = json['JorColectaFecha'];
    availableAgenda = json['JorColectaAgeHabDte'];
    if (json['Turnos'] != null) {
      appointments = new List<Appointment>();
      json['Turnos'].forEach((v) {
        appointments.add(new Appointment.fromJson(v));
      });
    }
  }
 
}