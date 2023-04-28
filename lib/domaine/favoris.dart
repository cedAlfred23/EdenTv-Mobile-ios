// import 'package:eden/domaine/programme.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Favoris {
  final String id;
  final String programme;
  final String user;

  const Favoris(
      {required this.id, required this.programme, required this.user});

  Map<String, dynamic> toMap() {
    return {'id': id, 'programme': programme, 'user': user};
  }

  @override
  String toString() {
    return "id: $id, programme: $programme, user: $user";
  }

  factory Favoris.fromJson(Map<String, dynamic> json) {
    return Favoris(
        id: json["id"], programme: json["programme"], user: json["user"]);
  }

  factory Favoris.fromJson2(Map<String, dynamic> json) {
    return Favoris(
        id: json["id"], programme: json["programme"], user: json["user"]);
  }

  Future<void> insertFavoris(Favoris favoris) async {
    final database =
        await openDatabase(join(await getDatabasesPath(), "edentv_bdd.db"));

    await database.insert("favoris", favoris.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Favoris>> favorisList() async {
    final database =
        await openDatabase(join(await getDatabasesPath(), "edentv_bdd.db"));

    final List<Map<String, dynamic>> maps = await database.query("favoris");

    return List.generate(maps.length, (i) {
      return Favoris(
        id: maps[i]['id'],
        programme: maps[i]['programme'],
        user: maps[i]['user'],
      );
    });
  }

  Future<void> deleteFavoris(String id) async {
    final database =
        await openDatabase(join(await getDatabasesPath(), "edentv_bdd.db"));
    await database.delete("favoris", where: 'id = ?', whereArgs: [id]);
  }
}
