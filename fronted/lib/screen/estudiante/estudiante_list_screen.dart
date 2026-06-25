import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/estudiante_viewmodel.dart';

class EstudianteListScreen extends StatefulWidget {
  const EstudianteListScreen({super.key});

  @override
  State<EstudianteListScreen> createState() =>
      _EstudianteListScreenState();
}

class _EstudianteListScreenState
    extends State<EstudianteListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<EstudianteViewModel>()
          .loadEstudiantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstudianteViewModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/estudiantes/create');
        },
        child: const Icon(Icons.add),
      ),

      body: vm.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : vm.error != null
              ? Center(
                  child: Text(
                    vm.error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : vm.estudiantes.isEmpty
                  ? const Center(
                      child: Text("No hay estudiantes"),
                    )
                  : ListView.builder(
                      itemCount: vm.estudiantes.length,
                      itemBuilder: (_, i) {

                        final e = vm.estudiantes[i];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),

                          child: ListTile(

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),

                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.school,
                              ),
                            ),

                            title: Text(
                              e.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  e.email ?? '',
                                ),

                                Text(
                                  'Código: ${e.codigoEstudiante}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                // BOTÓN EDITAR
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    context.go(
                                      '/estudiantes/${e.id}/edit',
                                    );
                                  },
                                ),

                                // BOTÓN ELIMINAR
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {

                                    final confirm =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                        title: const Text(
                                          '¿Eliminar estudiante?',
                                        ),

                                        content: Text(
                                          'Se eliminará "${e.name}" permanentemente.',
                                        ),

                                        actions: [

                                          TextButton(
                                            onPressed: () =>
                                                context.pop(false),
                                            child: const Text(
                                              'Cancelar',
                                            ),
                                          ),

                                          ElevatedButton(
                                            style:
                                                ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red,
                                            ),
                                            onPressed: () =>
                                                context.pop(true),
                                            child: const Text(
                                              'Eliminar',
                                              style: TextStyle(
                                                color:
                                                    Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true &&
                                        mounted) {

                                      final success =
                                          await vm
                                              .deleteEstudiante(
                                        e.id!,
                                      );

                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              success
                                                  ? 'Estudiante eliminado'
                                                  : 'Error al eliminar',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}