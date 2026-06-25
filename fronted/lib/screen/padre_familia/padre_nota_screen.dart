import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/padre_nota.dart';
import '../../viewmodels/padre_nota_viewmodel.dart';

class PadreNotaScreen extends StatefulWidget {
  final int estudianteId;

  const PadreNotaScreen({
    super.key,
    required this.estudianteId,
  });

  @override
  State<PadreNotaScreen> createState() => _PadreNotaScreenState();
}

class _PadreNotaScreenState extends State<PadreNotaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PadreNotaViewModel>().loadBoleta(widget.estudianteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PadreNotaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Boleta de Notas')),
      body: Builder(
        builder: (_) {
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(child: Text(vm.error!));
          }

          if (vm.periodos.isEmpty) {
            return const Center(child: Text('Sin notas registradas'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.periodos.length,
            itemBuilder: (_, index) =>
                _PeriodoCard(periodo: vm.periodos[index]),
          );
        },
      ),
    );
  }
}

class _PeriodoCard extends StatelessWidget {
  final PeriodoNota periodo;

  const _PeriodoCard({required this.periodo});

  Color _colorPromedio(double promedio) {
    if (promedio >= 70) return Colors.green;
    if (promedio >= 51) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título periodo
            Text(
              periodo.periodo,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Materia',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Promedio',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Materias
            if (periodo.materias.isEmpty)
              const Text(
                'Sin materias registradas',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...periodo.materias.map(
                (m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m.materia),
                      Text(
                        m.promedio.toString(),
                        style: TextStyle(
                          color: _colorPromedio(m.promedio),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Divider(height: 20),

            // Promedio general
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Promedio General:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  periodo.promedioGeneral.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _colorPromedio(periodo.promedioGeneral),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}