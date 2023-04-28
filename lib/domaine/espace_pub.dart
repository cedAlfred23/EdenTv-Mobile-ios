class EspacePub {
  final String? id;
  final String? title;
  final String? description;
  final String? couverture;
  final int? duree;
  final String? file;
  final String? dateDebut;
  final String? dateFin;

  const EspacePub(
      {required this.id,
      required this.title,
      required this.description,
      required this.couverture,
      required this.duree,
      required this.file,
      required this.dateDebut,
      required this.dateFin});

  factory EspacePub.fromJson(Map<String, dynamic> json) {
    return EspacePub(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        couverture: json['couverture'],
        duree: json['duree'],
        file: json['file'],
        dateDebut: json['dateDebut'],
        dateFin: json['dateFin']);
  }
}
