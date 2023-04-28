class Service {
  final String? id;
  final String? name;
  final String? description;
  final String? contact;
  final String? email;

  const Service(
      {required this.id,
      required this.name,
      required this.description,
      required this.contact,
      required this.email});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        contact: json["email"],
        email: json["email"]);
  }
}
