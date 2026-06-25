import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/asignacion_viewmodel.dart';
import '../../models/academic_period.dart';
import '../../models/mi_clase.dart';

class MisClasesScreen extends StatefulWidget {
  const MisClasesScreen({super.key});

  @override
  State<MisClasesScreen> createState() => _MisClasesScreenState();
}

class _MisClasesScreenState extends State<MisClasesScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AsignacionViewModel>().loadPeriodosYClases(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AsignacionViewModel>();

    return Scaffold(
      body: Column(
        children: [
          // ── Selector de periodo ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildSelector(vm),
          ),

          // ── Contenido ────────────────────────────────────────────────
          Expanded(
            child: vm.loadingClases
                ? const Center(child: CircularProgressIndicator())
                : vm.periodosProfesor.isEmpty
                    ? _empty(
                        Icons.calendar_today_outlined,
                        'No hay periodos académicos',
                      )
                    : vm.misClases.isEmpty
                        ? _empty(
                            Icons.class_outlined,
                            'No tienes clases asignadas en este periodo',
                          )
                        : _buildClases(vm.misClases),
          ),
        ],
      ),
    );
  }

  // ── Selector de periodo ──────────────────────────────────────────────
  Widget _buildSelector(AsignacionViewModel vm) {
    if (vm.periodosProfesor.isEmpty) {
      return const SizedBox(
          height: 48, child: Center(child: LinearProgressIndicator()));
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
          value: vm.periodoSeleccionadoClases,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: vm.periodosProfesor.map((p) {
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
                      child: const Text('ACTIVO',
                          style:
                              TextStyle(color: Colors.white, fontSize: 9)),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onChanged: (p) {
            if (p != null) vm.cambiarPeriodoClases(p);
          },
        ),
      ),
    );
  }

  // ── Grid de tarjetas agrupadas por curso+paralelo ────────────────────
  Widget _buildClases(List<MiClase> clases) {
    // Agrupar por curso+paralelo
    final Map<String, List<MiClase>> grupos = {};
    for (final c in clases) {
      final key = '${c.curso} "${c.paralelo}"';
      grupos.putIfAbsent(key, () => []).add(c);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 800 ? 2 : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: cols == 1 ? 1.6 : 1.4,
          ),
          itemCount: grupos.length,
          itemBuilder: (_, i) {
            final key = grupos.keys.elementAt(i);
            final materias = grupos[key]!;
            return _buildCard(key, materias);
          },
        );
      },
    );
  }

  // ── Tarjeta por curso+paralelo ───────────────────────────────────────
  Widget _buildCard(String titulo, List<MiClase> materias) {
    return Card(
      elevation: 3,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            color: _purple,
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Lista de materias
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: materias.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 16),
              itemBuilder: (context, i) {
                final m = materias[i];
                return ListTile(
                  dense: true,
                  title: Text(
                    m.materia ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Clase asignada',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
  final vm = context.read<AsignacionViewModel>();

  context.go(
 '/mis-clases/${vm.periodoSeleccionadoClases!.id}/${m.cursoId}/${m.paraleloId}/${m.id}'
 '?curso=${Uri.encodeComponent(m.curso ?? '')}'
 '&paralelo=${Uri.encodeComponent(m.paralelo ?? '')}'
 '&materia=${Uri.encodeComponent(m.materia ?? '')}',
);
},
                    child: const Text('Entrar',
                        style: TextStyle(fontSize: 13)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[350]),
          const SizedBox(height: 16),
          Text(msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }
}