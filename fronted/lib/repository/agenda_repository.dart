// agenda_repository.dart

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../models/agenda.dart';

class AgendaRepository {
  final Dio _dio;

  AgendaRepository(this._dio);

  Future<List<Agenda>> getAgenda({
    required int periodoId,
    required int asignacionId,
  }) async {
    final response = await _dio.get(
      '/periodos/$periodoId/asignaciones/$asignacionId/agenda',
    );

    return (response.data as List)
        .map((e) => Agenda.fromJson(e))
        .toList();
  }

  Future<Agenda> getAgendaDetalle(
    int id,
  ) async {
    final response = await _dio.get(
      '/agenda/$id',
    );

    return Agenda.fromJson(
      response.data,
    );
  }

  Future<Agenda> crearAgenda({
    required int periodoId,
    required int asignacionId,
    required String titulo,
    required String descripcion,
    required String tipo,
    String? fechaEntrega,
  }) async {
   final response = await _dio.post(
      '/periodos/$periodoId/asignaciones/$asignacionId/agenda',
      data: {
        'titulo': titulo,
        'descripcion': descripcion,
        'tipo': tipo,
        'fecha_entrega': fechaEntrega,
      },
    );
    return Agenda.fromJson(
      response.data['data'],
    );
  }

  Future<void> actualizarAgenda({
    required int agendaId,
    required String titulo,
    required String descripcion,
    required String tipo,
    String? fechaEntrega,
  }) async {
    await _dio.put(
      '/agenda/$agendaId',
      data: {
        'titulo': titulo,
        'descripcion': descripcion,
        'tipo': tipo,
        'fecha_entrega': fechaEntrega,
      },
    );
  }

  Future<void> eliminarAgenda(
    int agendaId,
  ) async {
    await _dio.delete(
      '/agenda/$agendaId',
    );
  }

  Future<void> subirArchivos({
    required int agendaId,
    required List<PlatformFile> archivos,
  }) async {
    final formData = FormData();

    for (final file in archivos) {
      formData.files.add(
        MapEntry(
          'archivos[]',
          MultipartFile.fromBytes(
            file.bytes!,
            filename: file.name,
          ),
        ),
      );
    }

    await _dio.post(
      '/agenda/$agendaId/subir-archivo',
      data: formData,
    );
  }

  Future<void> eliminarArchivo(
    int archivoId,
  ) async {
    await _dio.delete(
      '/agenda-archivos/$archivoId',
    );
  }

  Future<void> reemplazarArchivo({
    required int archivoId,
    required PlatformFile archivo,
  }) async {

    final formData = FormData.fromMap({
      'archivo':
          MultipartFile.fromBytes(
        archivo.bytes!,
        filename: archivo.name,
      ),
    });

    await _dio.post(
      '/agenda-archivos/$archivoId/reemplazar',
      data: formData,
    );
  }
}