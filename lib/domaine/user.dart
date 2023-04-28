import 'dart:developer';

class CurrentUser {
  final String? id;
  final String? uid;
  String? firstName;
  String? lastName;
  final String? countryCode;
  final String? country;
  final String? providerId;
  final String? displayName;
  String? numero;
  final String? email;
  final String? photoURL;
  final bool? fromFacebook;
  final bool? fromGoogle;
  final bool? fromApple;
  final bool? forSave;
  final String token;
  bool notifyOnProgram;

  CurrentUser(
      {required this.id,
      required this.uid,
      required this.firstName,
      required this.lastName,
      required this.countryCode,
      required this.country,
      required this.providerId,
      required this.displayName,
      required this.numero,
      required this.email,
      required this.photoURL,
      required this.fromFacebook,
      required this.fromGoogle,
      required this.fromApple,
      required this.forSave,
      required this.notifyOnProgram,
      required this.token});

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    log("user current: $json");
    return CurrentUser(
        id: json["user"]["id"] ?? "",
        uid: json["user"]["uid"],
        firstName: json["user"]["first_name"],
        lastName: json["user"]["last_name"],
        countryCode: json["user"]["countryCode"],
        country: json["user"]["country"],
        providerId: json["user"]["providerId"],
        displayName: json["user"]['displayName'],
        numero: json["user"]['phone'],
        email: json["user"]['email'],
        photoURL: json["user"]['profil_image'],
        fromApple: true,
        fromFacebook: json["user"]["fromFacebook"],
        fromGoogle: true,
        forSave: true,
        notifyOnProgram: json["user"]["notify_on_program"],
        token: json.containsKey("token") ? json["token"] : "");
  }
  Map<String, dynamic> toJson() => {
        "user": {
          "id": id,
          "uid": uid,
          "first_name": firstName,
          "last_name": lastName,
          "countryCode": countryCode,
          "country": country,
          "providerId": providerId,
          "displayName": displayName,
          "phone": numero,
          "email": email,
          "profil_image": photoURL,
          "fromApple": fromApple,
          "fromFacebook": fromFacebook,
          "fromGoogle": fromGoogle,
          "forSave": forSave,
          "notify_on_program": notifyOnProgram,
          "token": token,
        }
      };

  factory CurrentUser.fromJson2(Map<String, dynamic> json) {
    log("user current2: $json");

    return CurrentUser(
        id: json["id"] ?? "",
        uid: json["uid"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        countryCode: json["countryCode"],
        country: json["country"],
        providerId: json["providerId"],
        displayName: json['displayName'],
        numero: json['phone'],
        email: json['email'],
        photoURL: json['profil_image'],
        fromApple: true,
        fromFacebook: json["fromFacebook"],
        fromGoogle: true,
        forSave: true,
        notifyOnProgram: json.containsKey("notify_on_program")
            ? json["notify_on_program"]
            : false,
        token: json.containsKey("token") ? json["token"] : "");
  }

  Map<String, dynamic> toJson2() => {
        "id": id,
        "uid": uid,
        "first_name": firstName,
        "last_name": lastName,
        "countryCode": countryCode,
        "country": country,
        "providerId": providerId,
        "displayName": displayName,
        "phone": numero,
        "email": email,
        "profil_image": photoURL,
        "fromApple": fromApple,
        "fromFacebook": fromFacebook,
        "fromGoogle": fromGoogle,
        "forSave": forSave,
        "notify_on_program": notifyOnProgram,
        "token": token,
      };
}
