class Circular {
  final int?    id;
  final String? titulo;
  final String? contenido;
  final String? target;
  final String? publishedAt;
  final bool?   leido;
  final String? creadoPor;

  Circular({
    this.id,
    this.titulo,
    this.contenido,
    this.target,
    this.publishedAt,
    this.leido,
    this.creadoPor,
  });

  factory Circular.fromJson(Map<String, dynamic> json) {
    final users = json['users'] as List?;
    return Circular(
      id:          json['id'],
      titulo:      json['titulo'],
      contenido:   json['contenido'],
      target:      json['target'],
      publishedAt: json['published_at'],
      leido:       users != null && users.isNotEmpty
                       ? users[0]['leido'] == true
                       : null,
      creadoPor:   json['creator']?['name'],
    );
  }
}