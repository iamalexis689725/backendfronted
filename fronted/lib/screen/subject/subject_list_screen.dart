import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/subject_repository.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() =>
      _SubjectListScreenState();
}

class _SubjectListScreenState
    extends State<SubjectListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<SubjectViewModel>()
          .loadSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<SubjectViewModel>();

    return Scaffold(

      floatingActionButton:
          FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go('/materias/create');
        },
      ),

      body: vm.loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : vm.error != null

              ? Center(
                  child: Text(
                    vm.error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                )

              : vm.subjects.isEmpty

                  ? const Center(
                      child: Text(
                        'No hay materias',
                      ),
                    )

                  : ListView.builder(
                      itemCount:
                          vm.subjects.length,

                      itemBuilder: (_, i) {

                        final s =
                            vm.subjects[i];

                        return Card(

                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          elevation: 2,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),

                          child: ListTile(

                            leading:
                                const CircleAvatar(
                              child: Icon(
                                Icons.menu_book,
                              ),
                            ),

                            title: Text(
                              s.name ?? '',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            trailing: Row(

                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                // EDITAR

                                IconButton(

                                  icon: const Icon(
                                    Icons.edit,
                                    color:
                                        Colors.blue,
                                  ),

                                  onPressed: () {

                                    context.go(
                                      '/materias/${s.id}/edit',
                                    );
                                  },
                                ),

                                // ELIMINAR

                                IconButton(

                                  icon: const Icon(
                                    Icons.delete,
                                    color:
                                        Colors.red,
                                  ),

                                  onPressed:
                                      () async {

                                    final confirm =
                                        await showDialog<
                                            bool>(
                                      context:
                                          context,

                                      builder:
                                          (_) =>
                                              AlertDialog(

                                        title:
                                            const Text(
                                          '¿Eliminar materia?',
                                        ),

                                        content:
                                            Text(
                                          'Se eliminará "${s.name}" permanentemente.',
                                        ),

                                        actions: [

                                          TextButton(

                                            onPressed:
                                                () => context.pop(
                                                    false),

                                            child:
                                                const Text(
                                              'Cancelar',
                                            ),
                                          ),

                                          ElevatedButton(

                                            style:
                                                ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red,
                                            ),

                                            onPressed:
                                                () => context.pop(
                                                    true),

                                            child:
                                                const Text(
                                              'Eliminar',

                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm ==
                                            true &&
                                        mounted) {

                                      final success =
                                          await vm
                                              .deleteSubject(
                                        s.id!,
                                      );

                                      if (mounted) {

                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text(
                                              success
                                                  ? 'Materia eliminada'
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