class User {
  final String id;
  final String email;
  final String? name;

  User({required this.id, required this.email, this.name});

  factory User.fromJson(Map<String, dynamic> j) => User(id: j['id'].toString(), email: j['email'], name: j['name']);
}
