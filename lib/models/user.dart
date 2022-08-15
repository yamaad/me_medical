class TheUser {
  final String? uid;

  TheUser({this.uid});
}

class UserData {
  final String? uid;
  final String? name;
  final String? phone;
  final String? email;
  final String? location;
  final String? password;

  UserData(
      {this.uid,
      this.name,
      this.phone,
      this.email,
      this.location,
      this.password});
}
