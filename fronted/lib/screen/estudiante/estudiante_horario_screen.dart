// screen/estudiante/estudiante_horario_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/horario_curso.dart';
import '../../viewmodels/estudiante_horario_viewmodel.dart';

class EstudianteHorarioScreen extends StatefulWidget {
  const EstudianteHorarioScreen({super.key});

  @override
  State<EstudianteHorarioScreen> createState() =>
      _EstudianteHorarioScreenState();
}

class _EstudianteHorarioScreenState extends State<EstudianteHorarioScreen> {
  static const _purple = Color(0xFF4F46E5);

  static const _diasLabel = {
    'lunes':     'Lunes',
    'martes':    'Martes',
    'miercoles': 'Miércoles',
    'jueves':    'Jueves',
    'viernes':   'Viernes',
    'sabado':    'Sábado',
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<EstudianteHorarioViewModel>().loadHorario(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstudianteHorarioViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mi horario',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Vista semanal',
                style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(EstudianteHorarioViewModel vm) {
    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(vm.error!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => vm.loadHorario(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (vm.horario.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('Sin horario asignado',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('Aún no tienes clases registradas',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      );
    }

    final totalClases = vm.horario.values
        .fold<int>(0, (sum, lista) => sum + lista.length);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildResumen(vm.horario.length, totalClases),
        const SizedBox(height: 16),
        ...vm.horario.entries.map(
          (e) => _DiaCard(
            dia:    _diasLabel[e.key] ?? e.key,
            clases: e.value,
          ),
        ),
      ],
    );
  }

  Widget _buildResumen(int dias, int clases) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, color: _purple, size: 18),
          const SizedBox(width: 10),
          Text(
            '$dias ${dias == 1 ? 'día' : 'días'} · '
            '$clases ${clases == 1 ? 'clase' : 'clases'} en total',
            style: const TextStyle(
              color: _purple,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta por día ───────────────────────────────────────────────────────────
class _DiaCard extends StatelessWidget {
  final String dia;
  final List<HorarioItem> clases;

  const _DiaCard({required this.dia, required this.clases});

  static const _palette = {
    'Lunes':      {'bg': Color(0xFFEDE9FE), 'accent': Color(0xFF7C3AED)},
    'Martes':     {'bg': Color(0xFFDBEAFE), 'accent': Color(0xFF2563EB)},
    'Miércoles':  {'bg': Color(0xFFD1FAE5), 'accent': Color(0xFF059669)},
    'Jueves':     {'bg': Color(0xFFFEF3C7), 'accent': Color(0xFFD97706)},
    'Viernes':    {'bg': Color(0xFFFEE2E2), 'accent': Color(0xFFDC2626)},
    'Sábado':     {'bg': Color(0xFFFCE7F3), 'accent': Color(0xFFDB2777)},
  };

  @override
  Widget build(BuildContext context) {
    final colors = _palette[dia] ??
        {'bg': const Color(0xFFF3F4F6), 'accent': const Color(0xFF6B7280)};
    final bg     = colors['bg']     as Color;
    final accent = colors['accent'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del día
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Text(
                  dia,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: accent,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${clases.length} ${clases.length == 1 ? 'clase' : 'clases'}',
                    style: TextStyle(
                        fontSize: 11,
                        color: accent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          // Filas de clases
          ...clases.asMap().entries.map(
                (e) => _ClaseRow(
                  clase:       e.value,
                  accentColor: accent,
                  isLast:      e.key == clases.length - 1,
                ),
              ),
        ],
      ),
    );
  }
}

// ── Fila de cada clase ────────────────────────────────────────────────────────
class _ClaseRow extends StatelessWidget {
  final HorarioItem clase;
  final Color       accentColor;
  final bool        isLast;

  const _ClaseRow({
    required this.clase,
    required this.accentColor,
    required this.isLast,
  });

  String _fmt(String? t) => t?.substring(0, 5) ?? '--:--';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFF3F4F6), width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Horas
          SizedBox(
            width: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fmt(clase.horaInicio),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.arrow_downward_rounded,
                      size: 10, color: Colors.grey[400]),
                  const SizedBox(width: 2),
                  Text(
                    _fmt(clase.horaFin),
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF)),
                  ),
                ]),
              ],
            ),
          ),
          // Línea de acento
          Container(
            width: 3,
            height: 44,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Materia + profesor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clase.materia ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.person_outline,
                      size: 12, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(
                    clase.profesor ?? '',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}