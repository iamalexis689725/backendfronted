import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/periodo_evaluacion_viewmodel.dart';

class PeriodoEvaluacionListScreen extends StatefulWidget {
  final int periodoId;

  const PeriodoEvaluacionListScreen({
    super.key,
    required this.periodoId,
  });

  @override
  State<PeriodoEvaluacionListScreen> createState() =>
      _PeriodoEvaluacionListScreenState();
}

class _PeriodoEvaluacionListScreenState
    extends State<PeriodoEvaluacionListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<PeriodoEvaluacionViewModel>()
          .loadPeriodosEvaluacion(
            widget.periodoId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<PeriodoEvaluacionViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Periodos de Evaluación')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go(
            '/periodos/${widget.periodoId}/periodos-evaluacion/create',
          );
        },
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
              : vm.periodosEvaluacion.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay periodos de evaluación',
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          vm.periodosEvaluacion.length,
                      itemBuilder: (_, i) {

                        final periodo =
                            vm.periodosEvaluacion[i];

                        return Card(
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.assignment,
                              ),
                            ),
                            title: Text(
                              periodo.nombre ?? '',
                            ),
                            subtitle: Text(
                              'Orden: ${periodo.orden}',
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}