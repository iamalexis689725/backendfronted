import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/agenda_viewmodel.dart';

class AgendaListScreen extends StatefulWidget {
  final int periodoId;
  final int cursoId;
  final int paraleloId;
  final int asignacionId;

  const AgendaListScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.asignacionId,
  });

  @override
  State<AgendaListScreen> createState() =>
      _AgendaListScreenState();
}

class _AgendaListScreenState
    extends State<AgendaListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AgendaViewModel>().loadAgenda(
            periodoId: widget.periodoId,
            asignacionId: widget.asignacionId,
          );
    });
  }

  // ==========================================
  // ELIMINAR AGENDA
  // ==========================================

  Future<void> eliminarAgenda(
    int agendaId,
  ) async {

    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          '¿Eliminar agenda?',
        ),

        content: const Text(
          'Esta acción no se puede deshacer.',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),

            onPressed: () =>
                context.pop(true),

            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final vm =
        context.read<AgendaViewModel>();

    final ok =
        await vm.eliminarAgenda(
      agendaId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Agenda eliminada'
              : (vm.error ??
                  'Error al eliminar'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<AgendaViewModel>();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Agenda',
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {

          context.go(
            '/mis-clases/${widget.periodoId}/${widget.cursoId}/${widget.paraleloId}/${widget.asignacionId}/agendas/create',
          );
        },

        child: const Icon(
          Icons.add,
        ),
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

              : vm.agendas.isEmpty

                  ? const Center(
                      child: Text(
                        'No hay agendas',
                      ),
                    )

                  : ListView.builder(
                      itemCount:
                          vm.agendas.length,

                      itemBuilder: (_, i) {

                        final agenda =
                            vm.agendas[i];

                        return Card(
                          margin:
                              const EdgeInsets
                                  .all(10),

                          child: ListTile(

                            onTap: () {

                              context.go(
                                '/mis-clases/${widget.periodoId}/${widget.cursoId}/${widget.paraleloId}/${widget.asignacionId}/agendas/${agenda.id}',
                              );
                            },

                            leading:
                                CircleAvatar(
                              child: Text(
                                agenda.tipo
                                    .substring(
                                      0,
                                      1,
                                    )
                                    .toUpperCase(),
                              ),
                            ),

                            title: Text(
                              agenda.titulo,
                            ),

                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                if (agenda
                                        .descripcion !=
                                    null)
                                  Text(
                                    agenda.descripcion!,
                                  ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Text(
                                  'Tipo: ${agenda.tipo}',
                                ),

                                if (agenda
                                        .fechaEntrega !=
                                    null)
                                  Text(
                                    'Entrega: ${agenda.fechaEntrega}',
                                  ),
                              ],
                            ),

                            trailing:
                                IconButton(

                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),

                              onPressed: () {

                                eliminarAgenda(
                                  agenda.id!,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}