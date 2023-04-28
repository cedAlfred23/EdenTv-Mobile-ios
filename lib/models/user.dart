class User {
  String pseudo;
  String phoneNumber;

  User(this.pseudo, this.phoneNumber);

  Map<String, dynamic> toJson() =>
      {'pseudo': pseudo, 'phoneNumber': phoneNumber};
}
