class Animateur {
  final String? id;
  final String? photo;
  final String? nom;
  final String? prenom;
  final String? type;

  const Animateur(
      {required this.id,
      required this.photo,
      required this.nom,
      required this.prenom,
      required this.type});

  factory Animateur.fromJson(Map<String, dynamic> json) {
    return Animateur(
        id: json['id'],
        photo: json['photo'],
        nom: json['nom'],
        prenom: json['prenom'],
        type: json['type']);
  }
}
