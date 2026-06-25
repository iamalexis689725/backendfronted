  class Curso {
    final int? id;
    final String? nombre;
    final String? nivel;
    final String? descripcion;
    final bool? estado;
    final int? tenantId;

    Curso({
      this.id,
      this.nombre,
      this.nivel,
      this.descripcion,
      this.estado,
      this.tenantId,
    });

    factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      id: json['id'],
      nombre: json['nombre'],
      nivel: json['nivel'],
      descripcion: json['descripcion'],
      estado: json['estado']==1 || json['estado']==true,
      tenantId: json['tenant_id'],
    );
  }
}