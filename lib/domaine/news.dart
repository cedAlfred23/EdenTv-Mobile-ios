class News {
  final String id;
  final String? image;
  final String title;
  final String content;
  final String createdAt;

  News(
      {required this.id,
      required this.title,
      required this.image,
      required this.content,
      required this.createdAt});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        id: json['id'],
        image: json["image"],
        title: json["title"],
        content: json["content"],
        createdAt: json["createdAt"]);
  }
}
