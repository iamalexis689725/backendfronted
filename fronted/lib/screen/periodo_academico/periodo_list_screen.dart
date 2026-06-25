import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/academic_period_viewmodel.dart';

class PeriodoListScreen extends StatefulWidget {
  const PeriodoListScreen({super.key});

  @override
  State<PeriodoListScreen> createState() => _PeriodoListScreenState();
}

class _PeriodoListScreenState extends State<PeriodoListScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AcademicPeriodViewModel>(context, listen: false).loadPeriodos());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AcademicPeriodViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: _purple,
        onPressed: () async {context.go('/periodos/create');},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: vm.loading
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
          : vm.periodos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('No hay periodos académicos',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('Crea el primer periodo con el botón +',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: vm.periodos.length,
                  itemBuilder: (_, i) {
                    final p = vm.periodos[i];
                    final isActivo = p.activo ?? false;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: isActivo
                            ? const BorderSide(color: _purple, width: 2)
                            : BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                color: isActivo ? const Color(0xFFEDE9FE) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.calendar_month_outlined,
                                color: isActivo ? _purple : Colors.grey),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(p.nombre ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      if (isActivo) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _purple, borderRadius: BorderRadius.circular(20)),
                                          child: const Text('ACTIVO',
                                            style: TextStyle(color: Colors.white, fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${p.fechaInicio ?? ''} → ${p.fechaFin ?? ''}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                // Ver periodos de evaluación
                                IconButton(
                                  icon: const Icon(
                                    Icons.assignment_outlined,
                                    color: Color(0xFF4F46E5),
                                  ),
                                  tooltip: 'Periodos de evaluación',
                                  onPressed: () {
                                    context.go(
                                      '/periodos/${p.id}/periodos-evaluacion',
                                    );
                                  },
                                ),
                                if (!isActivo)
                                  IconButton(
                                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                                    tooltip: 'Activar periodo',
                                    onPressed: () async {
                                      final ok = await vm.activarPeriodo(p.id!);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(ok ? '✅ Periodo activado' : 'Error al activar')));
                                      }
                                    },
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Eliminar',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('¿Eliminar periodo?'),
                                        content: Text('Se eliminará "${p.nombre}" permanentemente.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => context.pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                            onPressed: () => context.pop(true),
                                            child: const Text('Eliminar',
                                              style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true && mounted) await vm.deletePeriodo(p.id!);
                                  },
                                ),
                              ],
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