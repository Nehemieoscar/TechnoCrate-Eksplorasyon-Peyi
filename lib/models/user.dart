class User {
  // Id itilizatè a
  final String id;
  // Non itilizatè a (username)
  final String nonItilizate;
  // Imel itilizatè a
  final String imel;
  // Modpas itilizatè a
  final String modpas;
  // Lè nou te kreye kont lan
  final DateTime kreyeLe;

  User({
    required this.id,
    required this.nonItilizate,
    required this.imel,
    required this.modpas,
    required this.kreyeLe,
  });

  // Konvèti itilizatè a an JSON pou sove li
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': nonItilizate,
      'email': imel,
      'password': modpas,
      'createdAt': kreyeLe.toIso8601String(),
    };
  }

  // Kreye yon itilizatè soti nan JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      nonItilizate: json['username'] ?? '',
      imel: json['email'] ?? '',
      modpas: json['password'] ?? '',
      kreyeLe: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
