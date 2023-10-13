class ProfesorModel{
  int? idProfe;
  String? nomProfe;
  int? idCarrera;
  String? email;

  ProfesorModel({
    this.idProfe,
    this.nomProfe,
    this.idCarrera,
    this.email,
  });

  factory ProfesorModel.fromMap(Map<String, dynamic> map) {
    return ProfesorModel(
      idProfe: map['idProfe'],
      nomProfe: map['nomProfe'],
      idCarrera: map['idCarrera'],
      email: map['email'],
    );
  }
}