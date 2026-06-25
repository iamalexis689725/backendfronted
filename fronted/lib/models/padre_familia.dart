class PadreFamilia {
  final int? id;
  final String? telefono;
  final String? ocupacion;
  final String? name;
  final String? email;

  PadreFamilia({
    this.id,
    this.telefono,
    this.ocupacion,
    this.name,
    this.email,
  });

  factory PadreFamilia.fromJson(Map<String, dynamic> json) {
    return PadreFamilia(
      id: json['id'],
      telefono: json['telefono'],
      ocupacion: json['ocupacion'],
      name: json['user']?['name'],
      email: json['user']?['email'],
    );
  }
}