class AgendaArchivo {
  final int? id;
  final String nombreOriginal;
  final String url;

  AgendaArchivo({
    this.id,
    required this.nombreOriginal,
    required this.url,
  });

  factory AgendaArchivo.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'http://192.168.100.206:8000';
    final rawUrl = json['url'] ?? '';
    final fullUrl = rawUrl.startsWith('http') ? rawUrl : '$baseUrl$rawUrl';

    return AgendaArchivo(
      id: json['id'],
      nombreOriginal: json['nombre_original'] ?? '',
      url: fullUrl,
    );
  }
}