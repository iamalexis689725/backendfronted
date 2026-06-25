import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/asistencia.dart';
import '../../models/estudiante_clase.dart';

import '../../viewmodels/asistencia_viewmodel.dart';
import '../../viewmodels/estudiantes_clase_viewmodel.dart';

class AsistenciaCreateScreen extends StatefulWidget {
  final int periodoId;
  final int cursoId;
  final int paraleloId;
  final int asignacionId;

  const AsistenciaCreateScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.asignacionId,
  });

  @override
  State<AsistenciaCreateScreen> createState() =>
      _AsistenciaCreateScreenState();
}

class _AsistenciaCreateScreenState
    extends State<AsistenciaCreateScreen> {
  final Map<int, String> estados = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EstudiantesClaseViewModel>().load(
            periodoId: widget.periodoId,
            cursoId: widget.cursoId,
            paraleloId: widget.paraleloId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final estudiantesVM =
        context.watch<EstudiantesClaseViewModel>();

    final vm = context.watch<AsistenciaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar Asistencia'),
      ),
      body: estudiantesVM.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  //generar lista de estudiantes con dropdown de estado de asistencia
                  child: ListView.builder(
                    itemCount:
                        estudiantesVM.estudiantes.length,
                    itemBuilder: (_, i) {
                      final EstudianteClase e =
                          estudiantesVM.estudiantes[i];

                      estados.putIfAbsent(
                        e.id!,
                        () => 'presente',
                      );

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(e.nombre ?? ''),
                          subtitle:
                              Text(e.email ?? ''),
                          trailing:
                              DropdownButton<String>(
                            value: estados[e.id],
                            items: const [
                              DropdownMenuItem(
                                value: 'presente',
                                child:
                                    Text('Presente'),
                              ),
                              DropdownMenuItem(
                                value: 'falta',
                                child: Text('Falta'),
                              ),
                              DropdownMenuItem(
                                value: 'tarde',
                                child: Text('Tarde'),
                              ),
                              DropdownMenuItem(
                                value: 'justificado',
                                child: Text(
                                    'Justificado'),
                              ),
                            ],
                            onChanged: (v) {
                              setState(() {
                                estados[e.id!] = v!;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔥 ERROR BACKEND
                if (vm.error != null) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      vm.error!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],

                Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.saving
                          ? null
                          : () async {
                              final estudiantes =
                                  estudiantesVM
                                      .estudiantes;

                              final asistencias =
                                  estudiantes
                                      .map((e) {
                                return AsistenciaDetalle(
                                  estudianteId:
                                      e.id,
                                  estado:
                                      estados[
                                              e.id] ??
                                          'presente',
                                );
                              }).toList();

                              final ok =
                                  await vm
                                      .registrarAsistencia(
                                periodoId:
                                    widget
                                        .periodoId,
                                asignacionId:
                                    widget
                                        .asignacionId,
                                fecha:
                                    DateTime.now()
                                        .toString()
                                        .split(
                                            ' ')
                                        .first,
                                asistencias:
                                    asistencias,
                              );

                              if (!mounted) {
                                return;
                              }

                              if (ok) {
                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Asistencia registrada',
                                    ),
                                  ),
                                );

                                context.pop();
                              }
                            },
                      child: vm.saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Guardar Asistencia',
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}