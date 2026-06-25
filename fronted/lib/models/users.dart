class Users {
  final int? id;
  final String name;
  final String email;
  final String token;
  final List<String> roles;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.roles,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    List<String> rolesList = [];

    if (json['roles'] != null) {
      rolesList = List<String>.from(json['roles']);
    } else if (json['role'] != null) {
      rolesList = [json['role']];
    }

    return Users(
      id: json['user']?['id'],
      name: json['user']?['name'] ?? '',
      email: json['user']?['email'] ?? '',
      token: json['token'] ?? '',
      roles: rolesList,
    );
  }
}