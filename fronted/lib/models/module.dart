class ModuleModel {

  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final bool activo;

  ModuleModel({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.activo,
  });

  factory ModuleModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return ModuleModel(

      id: json['id'],

      codigo: json['codigo'] ?? '',

      nombre: json['nombre'] ?? '',

      descripcion:
          json['descripcion'] ?? '',

      // 👇 ESTA ES LA CLAVE
      activo:
          json['activo'] == 1 ||
          json['activo'] == true,
    );
  }
}