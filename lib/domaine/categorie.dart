class Categorie {
  final String? id;
  final String? title;

  const Categorie({required this.id, required this.title});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(id: json["id"], title: json["title"]);
  }

  factory Categorie.fromJson2(Map<String, dynamic> json) {
    return Categorie(id: json["id"], title: "");
  }
}
