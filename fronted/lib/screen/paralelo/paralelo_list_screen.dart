import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/paralelo_viewmodel.dart';
import '../../viewmodels/academic_period_viewmodel.dart';

class ParaleloListScreen extends StatefulWidget {
  final int cursoId;

  const ParaleloListScreen({super.key, required this.cursoId});

  @override
  State<ParaleloListScreen> createState() => _ParaleloListScreenState();
}

class _ParaleloListScreenState extends State<ParaleloListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final periodoVM = context.read<AcademicPeriodViewModel>();

      // 🔥 Esperar periodo (CLAVE en web)
      if (periodoVM.periodoActivo == null) {
        await periodoVM.loadPeriodoActivo();
      }

      final periodoId = periodoVM.periodoActivo?.id;

      if (periodoId != null) {
        await context.read<ParaleloViewModel>().loadParalelosByCurso(
          periodoId,
          widget.cursoId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParaleloViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paralelos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/cursos/${widget.cursoId}/paralelos/create');
        },
        child: const Icon(Icons.add),
      ),

      body: vm.loading && vm.paralelos.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
          : vm.paralelos.isEmpty
              ? const Center(child: Text('No hay paralelos'))
              : ListView.builder(
                  itemCount: vm.paralelos.length,
                  itemBuilder: (_, i) {
                    final p = vm.paralelos[i];

                    return ListTile(
                      title: Text('Paralelo ${p.nombre}'),
                      subtitle: Text(p.turno ?? ''),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔥 VER HORARIO
                          IconButton(
                            icon: const Icon(
                              Icons.calendar_view_week_rounded,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              context.go(
                                '/cursos/${widget.cursoId}/paralelos/${p.id}/horario',
                              );
                            },
                          ),

                          // 🔥 ELIMINAR
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await vm.deleteParalelo(p.id!);

                              final periodoVM =
                                  context.read<AcademicPeriodViewModel>();

                              final periodoId =
                                  periodoVM.periodoActivo?.id;

                              if (periodoId != null) {
                                await vm.loadParalelosByCurso(
                                  periodoId,
                                  widget.cursoId,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}