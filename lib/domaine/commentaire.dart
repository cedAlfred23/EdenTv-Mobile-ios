class Commentaire {
  final String username;
  final String message;
  final String date;

  const Commentaire(
      {required this.username, required this.message, required this.date});

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
        date: json["date"],
        message: json["message"],
        username: json["username"]);
  }
}
