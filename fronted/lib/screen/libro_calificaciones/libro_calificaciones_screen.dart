import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/libro_calificaciones_viewmodel.dart';

class LibroCalificacionesScreen extends StatefulWidget {
  final int asignacionId;

  const LibroCalificacionesScreen({
    super.key,
    required this.asignacionId,
  });

  @override
  State<LibroCalificacionesScreen> createState() =>
      _LibroCalificacionesScreenState();
}

class _LibroCalificacionesScreenState extends State<LibroCalificacionesScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LibroCalificacionesViewModel>().loadPeriodos(widget.asignacionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LibroCalificacionesViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Libro de Calificaciones'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        onPressed: vm.saving
            ? null
            : () async {
                await vm.guardarNotas(widget.asignacionId);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(vm.error ?? 'Notas guardadas correctamente'),
                  ),
                );
              },
        icon: vm.saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.save),
        label: const Text('Guardar'),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text(vm.error!))
              : Column(
                  children: [
                    // ── Selector de periodo ──────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: DropdownButtonFormField(
                        value: vm.periodoSeleccionado,
                        decoration: InputDecoration(
                          labelText: 'Periodo de evaluación',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: vm.periodosEvaluacion
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.nombre ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          vm.seleccionarPeriodo(widget.asignacionId, value);
                        },
                      ),
                    ),

                    // ── Tabla ────────────────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    _purple.withOpacity(0.08),
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: _purple,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                  dataRowMinHeight: 52,
                                  dataRowMaxHeight: 52,
                                  columnSpacing: 20,
                                  columns: [
                                    const DataColumn(
                                      label: Text('Estudiante'),
                                    ),
                                    ...vm.criterios.map(
                                      (c) => DataColumn(
                                        label: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(c.nombre),
                                            Text(
                                              '${c.porcentaje.toStringAsFixed(0)}%',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const DataColumn(
                                      label: Text('Promedio'),
                                    ),
                                  ],
                                  rows: vm.estudiantes.map((estudiante) {
                                    final promedio = estudiante.promedio;
                                    final promedioColor = promedio >= 51
                                        ? Colors.green
                                        : Colors.red;

                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: 180,
                                            child: Text(
                                              estudiante.estudiante,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...vm.criterios.map((criterio) {
                                          final nota = estudiante.notas.firstWhere(
                                            (n) => n.criterioId == criterio.id,
                                          );
                                          return DataCell(
                                            SizedBox(
                                              width: 80,
                                              child: TextFormField(
                                                initialValue: nota.nota.toString(),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 8,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                                onChanged: (value) {
                                                  vm.actualizarNota(
                                                    estudianteId: estudiante.estudianteId,
                                                    criterioId: criterio.id,
                                                    nota: double.tryParse(value) ?? 0,
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: promedioColor.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              promedio.toStringAsFixed(2),
                                              style: TextStyle(
                                                color: promedioColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}