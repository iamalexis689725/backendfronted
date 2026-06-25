import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/padre_familia_viewmodel.dart';
import '../../viewmodels/estudiante_viewmodel.dart';

class PadreAsignarEstudianteScreen extends StatefulWidget {
  final int padreId;

  const PadreAsignarEstudianteScreen({
    super.key,
    required this.padreId,
  });

  @override
  State<PadreAsignarEstudianteScreen> createState() =>
      _PadreAsignarEstudianteScreenState();
}

class _PadreAsignarEstudianteScreenState
    extends State<PadreAsignarEstudianteScreen> {
  int? estudianteSeleccionado;

  String parentesco = "padre";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EstudianteViewModel>().loadEstudiantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final padreVM = context.watch<PadreFamiliaViewModel>();

    final estudianteVM = context.watch<EstudianteViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Asignar Estudiante",
        ),
      ),
      body: estudianteVM.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<int>(
                    value: estudianteSeleccionado,
                    decoration: const InputDecoration(
                      labelText: "Estudiante",
                      border: OutlineInputBorder(),
                    ),
                    items: estudianteVM.estudiantes
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(
                              e.name ?? "",
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        estudianteSeleccionado = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: parentesco,
                    decoration: const InputDecoration(
                      labelText: "Parentesco",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "padre",
                        child: Text("Padre"),
                      ),
                      DropdownMenuItem(
                        value: "madre",
                        child: Text("Madre"),
                      ),
                      DropdownMenuItem(
                        value: "tutor",
                        child: Text("Tutor"),
                      ),
                      DropdownMenuItem(
                        value: "abuelo",
                        child: Text("Abuelo"),
                      ),
                      DropdownMenuItem(
                        value: "otro",
                        child: Text("Otro"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          parentesco = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: padreVM.assigning
                          ? null
                          : () async {
                              if (estudianteSeleccionado == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Seleccione un estudiante",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final ok =
                                  await padreVM.asignarEstudiante(
                                padreId: widget.padreId,
                                estudianteId: estudianteSeleccionado!,
                                parentesco: parentesco,
                              );

                              if (!mounted) return;

                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Estudiante asignado correctamente",
                                    ),
                                  ),
                                );

                                context.pop();
                              } else if (padreVM.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      padreVM.error!,
                                    ),
                                  ),
                                );
                              }
                            },
                      child: padreVM.assigning
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Asignar Estudiante",
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}