import 'package:eden/domaine/programme.dart';
import 'package:eden/domaine/user.dart';

class FavorisObj {
  final String id;
  final Programme programme;
  final CurrentUser cUser;

  const FavorisObj(
      {required this.id, required this.programme, required this.cUser});

  factory FavorisObj.fromJson(Map<String, dynamic> json) {
    // log("favoris json = $json");
    return FavorisObj(
        id: json["id"],
        programme: Programme.fromJson2(json["programme"]),
        cUser: CurrentUser.fromJson2(json["user"]));
  }
}
