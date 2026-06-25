import 'estudiante.dart';
import 'curso.dart';
import 'paralelo.dart';
import 'academic_period.dart';

class Inscripcion {
  final int? id;
  final int? estudianteId;
  final int? cursoId;
  final int? paraleloId;
  final int? academicPeriodId;
  final Estudiante? estudiante;
  final Curso? curso;
  final Paralelo? paralelo;
  final AcademicPeriod? periodo;

  Inscripcion({
    this.id,
    this.estudianteId,
    this.cursoId,
    this.paraleloId,
    this.academicPeriodId,
    this.estudiante,
    this.curso,
    this.paralelo,
    this.periodo,
  });

  factory Inscripcion.fromJson(Map<String, dynamic> json) {
    return Inscripcion(
      id: json['id'],
      estudianteId: json['estudiante_id'],
      cursoId: json['curso_id'],
      paraleloId: json['paralelo_id'],
      academicPeriodId: json['academic_period_id'],
      estudiante: json['estudiante'] != null
          ? Estudiante.fromJson(json['estudiante'])
          : null,
      curso: json['curso'] != null ? Curso.fromJson(json['curso']) : null,
      paralelo: json['paralelo'] != null
          ? Paralelo.fromJson(json['paralelo'])
          : null,
      periodo: json['periodo'] != null
          ? AcademicPeriod.fromJson(json['periodo'])
          : null,
    );
  }
}