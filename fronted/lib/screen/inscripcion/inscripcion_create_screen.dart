import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/inscripcion_viewmodel.dart';
import '../../viewmodels/estudiante_viewmodel.dart';
import '../../viewmodels/curso_viewmodel.dart';
import '../../viewmodels/paralelo_viewmodel.dart';
import '../../viewmodels/academic_period_viewmodel.dart';
import '../../models/estudiante.dart';
import '../../models/curso.dart';
import '../../models/paralelo.dart';

class InscripcionCreateScreen extends StatefulWidget {
  const InscripcionCreateScreen({super.key});

  @override
  State<InscripcionCreateScreen> createState() =>
      _InscripcionCreateScreenState();
}

class _InscripcionCreateScreenState extends State<InscripcionCreateScreen> {
  static const _purple = Color(0xFF4F46E5);

  Estudiante? _estudianteSelected;
  Curso? _cursoSelected;
  Paralelo? _paraleloSelected;
  List<Paralelo> _paralelosFiltrados = [];
  bool _loadingParalelos = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<EstudianteViewModel>().loadEstudiantes();
      await context.read<CursoViewModel>().loadCursos();
    });
  }

  Future<void> _onCursoChanged(Curso? curso) async {
    setState(() {
      _cursoSelected = curso;
      _paraleloSelected = null;
      _paralelosFiltrados = [];
    });

    if (curso == null) return;

    final periodoActivo =
        context.read<AcademicPeriodViewModel>().periodoActivo;
    if (periodoActivo == null) return;

    setState(() => _loadingParalelos = true);

    await context.read<ParaleloViewModel>().loadParalelosByCurso(
          periodoActivo.id!,
          curso.id!,
        );

    if (mounted) {
      setState(() {
        _paralelosFiltrados = context.read<ParaleloViewModel>().paralelos;
        _loadingParalelos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inscripcionVM = context.watch<InscripcionViewModel>();
    final estudianteVM = context.watch<EstudianteViewModel>();
    final cursoVM = context.watch<CursoViewModel>();
    final periodoVM = context.watch<AcademicPeriodViewModel>();
    final periodoActivo = periodoVM.periodoActivo;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Nueva Inscripción'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.assignment_ind_outlined,
                              size: 60, color: _purple),
                          SizedBox(height: 8),
                          Text(
                            'Inscribir Estudiante',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Periodo activo (solo lectura)
                    if (periodoActivo != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                color: _purple, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Periodo activo: ${periodoActivo.nombre ?? ''}',
                                style: const TextStyle(
                                    color: _purple,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Text(
                          '⚠️ No hay periodo activo. Activa un periodo antes de inscribir.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Dropdown Estudiante
                    _label('Estudiante'),
                    const SizedBox(height: 6),
                    estudianteVM.loading
                        ? const LinearProgressIndicator()
                        : _dropdown<Estudiante>(
                            hint: 'Selecciona un estudiante',
                            value: _estudianteSelected,
                            items: estudianteVM.estudiantes,
                            label: (e) =>
                                '${e.name ?? ''} (${e.codigoEstudiante ?? ''})',
                            onChanged: (e) =>
                                setState(() => _estudianteSelected = e),
                          ),

                    const SizedBox(height: 16),

                    // Dropdown Curso
                    _label('Curso'),
                    const SizedBox(height: 6),
                    cursoVM.loading
                        ? const LinearProgressIndicator()
                        : _dropdown<Curso>(
                            hint: 'Selecciona un curso',
                            value: _cursoSelected,
                            items: cursoVM.cursos,
                            label: (c) =>
                                '${c.nombre ?? ''} - ${c.nivel ?? ''}',
                            onChanged: _onCursoChanged,
                          ),

                    const SizedBox(height: 16),

                    // Dropdown Paralelo
                    _label('Paralelo'),
                    const SizedBox(height: 6),
                    _loadingParalelos
                        ? const LinearProgressIndicator()
                        : _dropdown<Paralelo>(
                            hint: _cursoSelected == null
                                ? 'Selecciona un curso primero'
                                : 'Selecciona un paralelo',
                            value: _paraleloSelected,
                            items: _paralelosFiltrados,
                            label: (p) =>
                                'Paralelo ${p.nombre ?? ''}${p.turno != null ? ' • ${p.turno}' : ''}',
                            onChanged: _cursoSelected == null
                                ? null
                                : (p) =>
                                    setState(() => _paraleloSelected = p),
                          ),

                    if (inscripcionVM.error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        inscripcionVM.error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Botón inscribir
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _purple,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: inscripcionVM.creating ||
                                periodoActivo == null
                            ? null
                            : () async {
                                if (_estudianteSelected == null ||
                                    _cursoSelected == null ||
                                    _paraleloSelected == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Completa todos los campos')),
                                  );
                                  return;
                                }

                                FocusScope.of(context).unfocus();

                                final success = await context
                                    .read<InscripcionViewModel>()
                                    .createInscripcion(
                                      periodoId: periodoActivo.id!,
                                      estudianteId:
                                          _estudianteSelected!.id!,
                                      cursoId: _cursoSelected!.id!,
                                      paraleloId: _paraleloSelected!.id!,
                                    );

                                if (!mounted) return;

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Estudiante inscrito correctamente',
                                      ),
                                    ),
                                  );
                                  context.go('/inscripciones');
                                }
                              },
                        child: inscripcionVM.creating
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Inscribir Estudiante',
                                style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13));

  Widget _dropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T?>? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      hint: Text(hint, style: const TextStyle(color: Colors.grey)),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child:
                    Text(label(e), overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}