class AsistenciaDetalle {
  final int? estudianteId;
  final String? estudiante;
  final String estado;
  final String? observacion;

  AsistenciaDetalle({
    this.estudianteId,
    this.estudiante,
    required this.estado,
    this.observacion,
  });

  factory AsistenciaDetalle.fromJson(
    Map<String, dynamic> json,
  ) {
    return AsistenciaDetalle(
      estudianteId: json['estudiante_id'],
      estudiante: json['estudiante']?['user']?['name'],
      estado: json['estado'] ?? 'presente',
      observacion: json['observacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estudiante_id': estudianteId,
      'estado': estado,
      'observacion': observacion,
    };
  }
}

class Asistencia {
  final int? id;
  final String? fecha;
  final List<AsistenciaDetalle> detalles;

  Asistencia({
    this.id,
    this.fecha,
    required this.detalles,
  });

  factory Asistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    return Asistencia(
      id: json['id'],
      fecha: json['fecha'],
      detalles: (json['detalles'] as List? ?? [])
          .map(
            (e) => AsistenciaDetalle.fromJson(e),
          )
          .toList(),
    );
  }
}