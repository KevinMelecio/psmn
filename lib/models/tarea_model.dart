import 'dart:ffi';

class TareaModel {
  int? idTarea;
  String? nomTarea;
  String? fecExpiracion; // Debes convertir esto a DateTime cuando lo uses
  String? fecRecordatorio; // Debes convertir esto a DateTime cuando lo uses
  String? desTarea;
  String? realizada;
  int? idProfe;
  String? nomProfe;

  TareaModel({
    this.idTarea,
    this.nomTarea,
    this.fecExpiracion,
    this.fecRecordatorio,
    this.desTarea,
    this.realizada,
    this.idProfe,
    this.nomProfe
  });

  factory TareaModel.fromMap(Map<String,dynamic> map){
    return TareaModel(
      idTarea: map['idTarea'],
      nomTarea: map['nomTarea'],
      fecExpiracion: map['fecExpiracion'],
      fecRecordatorio: map['fecRecordatorio'],
      desTarea: map['desTarea'],
      realizada: map['realizada'],
      idProfe: map['idProfe'],
      nomProfe: map['nomProfe']
    );
  }
}
