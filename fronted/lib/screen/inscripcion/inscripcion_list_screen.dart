import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/inscripcion_viewmodel.dart';
import '../../models/academic_period.dart';
import '../../models/inscripcion.dart';

class InscripcionListScreen extends StatefulWidget {
  const InscripcionListScreen({super.key});

  @override
  State<InscripcionListScreen> createState() => _InscripcionListScreenState();
}

class _InscripcionListScreenState extends State<InscripcionListScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<InscripcionViewModel>().loadPeriodos(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InscripcionViewModel>();

    return Scaffold(
      body: Column(
        children: [
          // ── Barra superior: selector + botón ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(child: _buildSelector(vm)),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nueva Inscripción'),
                  onPressed: () => context.go('/inscripciones/create'),
                ),
              ],
            ),
          ),

          // ── Cuerpo ──────────────────────────────────────────────────
          Expanded(
            child: vm.loading
                ? const Center(child: CircularProgressIndicator())
                : vm.periodos.isEmpty
                    ? _emptyState(
                        Icons.calendar_today_outlined,
                        'No hay periodos académicos',
                        'Crea un periodo primero',
                      )
                    : vm.inscripciones.isEmpty
                        ? _emptyState(
                            Icons.assignment_outlined,
                            'No hay inscripciones en este periodo',
                            'Inscribe estudiantes con el botón de arriba',
                          )
                        : _buildContent(vm),
          ),
        ],
      ),
    );
  }

  // ── Dropdown de periodos ─────────────────────────────────────────────
  Widget _buildSelector(InscripcionViewModel vm) {
    if (vm.periodos.isEmpty) {
      return const SizedBox(
        height: 48,
        child: Center(child: LinearProgressIndicator()),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[350]!),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AcademicPeriod>(
          value: vm.periodoSeleccionado,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: vm.periodos.map((p) {
            return DropdownMenuItem<AcademicPeriod>(
              value: p,
              child: Row(
                children: [
                  Text(p.nombre ?? ''),
                  if (p.activo == true) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ACTIVO',
                        style: TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onChanged: (p) {
            if (p != null) vm.cambiarPeriodo(p);
          },
        ),
      ),
    );
  }

  // ── Grid/Lista responsiva ────────────────────────────────────────────
  Widget _buildContent(InscripcionViewModel vm) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 900
            ? 3
            : constraints.maxWidth > 600
                ? 2
                : 1;

        if (cols == 1) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.inscripciones.length,
            itemBuilder: (_, i) =>
                _buildCard(context, vm, vm.inscripciones[i]),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 2.2,
          ),
          itemCount: vm.inscripciones.length,
          itemBuilder: (_, i) =>
              _buildCard(context, vm, vm.inscripciones[i]),
        );
      },
    );
  }

  // ── Tarjeta de inscripción ───────────────────────────────────────────
  Widget _buildCard(
      BuildContext context, InscripcionViewModel vm, Inscripcion ins) {
    final nombre = ins.estudiante?.name ?? 'Sin nombre';
    final email = ins.estudiante?.email ?? '';
    final curso = ins.curso?.nombre ?? '-';
    final paralelo = ins.paralelo?.nombre ?? '-';
    final periodo = ins.periodo?.nombre ?? vm.periodoSeleccionado?.nombre ?? '-';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nombre
            
            Text(
              nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: _purple,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // Email
            Text(
              email,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Curso - Paralelo
            Text(
              '$curso - $paralelo',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            // Periodo
            Text(
              periodo,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

           const SizedBox(height: 12),

            // Botones
            Row(
              children: [
                _actionButton(
                  label: 'Editar',
                  color: Colors.orange,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Editar próximamente')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _actionButton(
                  label: 'Eliminar',
                  color: Colors.red,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text('¿Eliminar inscripción?'),
                        content: Text(
                            'Se eliminará la inscripción de "$nombre".'),
                        actions: [
                          TextButton(
  onPressed: () => context.pop(false), // cierra el dialog
  child: const Text('Cancelar'),
),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                              onPressed: () => context.pop(true),
                              child: const Text('Eliminar',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      final ok = await vm.deleteInscripcion(ins.id!);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(ok
                              ? 'Inscripción eliminada'
                              : 'Error al eliminar'),
                        ));
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[350]),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}