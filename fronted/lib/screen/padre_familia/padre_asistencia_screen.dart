import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/padre_asistencia_viewmodel.dart';

class PadreAsistenciaScreen extends StatefulWidget {
  final int estudianteId;

  const PadreAsistenciaScreen({
    super.key,
    required this.estudianteId,
  });

  @override
  State<PadreAsistenciaScreen> createState() => _PadreAsistenciaScreenState();
}

class _PadreAsistenciaScreenState extends State<PadreAsistenciaScreen> {
  static const _purple = Color(0xFF4F46E5);
  String? materiaSeleccionada;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PadreAsistenciaViewModel>().loadAsistenciasHijo(widget.estudianteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PadreAsistenciaViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Asistencias'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ── Filtro de materia ────────────────────────
            DropdownButtonFormField<String>(
              value: materiaSeleccionada,
              decoration: InputDecoration(
                labelText: 'Filtrar por materia',
                prefixIcon: const Icon(Icons.menu_book_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: const Text('Todas las materias'),
              items: vm.materias
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (value) async {
                setState(() => materiaSeleccionada = value);
                await vm.loadAsistenciasHijo(widget.estudianteId, materia: value);
              },
            ),

            const SizedBox(height: 16),

            // ── Total faltas ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.event_busy, color: Colors.red.shade700, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total de faltas',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      Text(
                        '${vm.totalFaltas}',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Lista ────────────────────────────────────
            Expanded(
              child: Builder(
                builder: (_) {
                  if (vm.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.error != null) {
                    return Center(child: Text(vm.error!));
                  }

                  if (vm.faltas.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                          SizedBox(height: 12),
                          Text(
                            '¡Sin faltas registradas!',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: vm.faltas.length,
                    itemBuilder: (_, i) {
                      final falta = vm.faltas[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.event_busy, color: Colors.red.shade400, size: 22),
                          ),
                          title: Text(
                            falta.materia,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(falta.fecha),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              'Falta',
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}