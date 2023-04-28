class Contact {
  final String? id;
  final String? user;
  final String? object;
  final String? content;
  final String? service;

  const Contact(
      {required this.id,
      required this.user,
      required this.object,
      required this.content,
      required this.service});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        id: json["id"],
        user: json["user"],
        object: json["object"],
        content: json["content"],
        service: json["service"]);
  }
}
