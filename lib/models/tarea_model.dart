class TareaModel {
  int? idTarea;
  String? nomTarea;
  int? fecExpiracion; // Debes convertir esto a DateTime cuando lo uses
  int? fecRecordatorio; // Debes convertir esto a DateTime cuando lo uses
  String? desTarea;
  int? realizada;
  int? idProfe;

  TareaModel({
    this.idTarea,
    this.nomTarea,
    this.fecExpiracion,
    this.fecRecordatorio,
    this.desTarea,
    this.realizada,
    this.idProfe,
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
    );
  }
}
