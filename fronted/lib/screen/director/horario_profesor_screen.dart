import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/profesor.dart';
import '../../models/asignacion.dart';
import '../../viewmodels/asignacion_viewmodel.dart';

class HorarioProfesorScreen extends StatefulWidget {

final int profesorId;
  const HorarioProfesorScreen({super.key, required this.profesorId});

  @override
  State<HorarioProfesorScreen> createState() => _HorarioProfesorScreenState();
}

class _HorarioProfesorScreenState extends State<HorarioProfesorScreen> {
  static const _purple = Color(0xFF4F46E5);

  // Orden canónico de días
  static const _diasOrden = [
    'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AsignacionViewModel>(context, listen: false)
            .loadHorario(widget.profesorId));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AsignacionViewModel>(context);

    final diasOrdenados = _diasOrden
        .where((d) => vm.horario.containsKey(d))
        .toList();

    final totalClases = vm.horario.values
        .fold<int>(0, (sum, lista) => sum + lista.length);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.profesorId.toString(), // Assuming profesorId is an integer
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Horario semanal',
                style: TextStyle(
                    fontSize: 11, color: Colors.white.withOpacity(0.7))),
          ],
        ),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.horario.isEmpty
              ? _buildEmpty()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildResumen(diasOrdenados.length, totalClases),
                    const SizedBox(height: 16),
                    ...diasOrdenados.map(
                      (dia) => _DiaCard(
                        dia: dia,
                        clases: vm.horario[dia]!,
                      ),
                    ),
                  ],
                ),
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
            '$dias ${dias == 1 ? 'día' : 'días'} · $clases ${clases == 1 ? 'clase' : 'clases'} en total',
            style: const TextStyle(
                color: _purple, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Sin horario asignado',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Asigna un horario desde la pantalla anterior',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Tarjeta por día ───────────────────────────────────────────────────────────
class _DiaCard extends StatelessWidget {
  final String dia;
  final List<Asignacion> clases;

  const _DiaCard({required this.dia, required this.clases});

  static const _palette = {
    'Lunes':     {'bg': Color(0xFFEDE9FE), 'accent': Color(0xFF7C3AED)},
    'Martes':    {'bg': Color(0xFFDBEAFE), 'accent': Color(0xFF2563EB)},
    'Miercoles': {'bg': Color(0xFFD1FAE5), 'accent': Color(0xFF059669)},
    'Jueves':    {'bg': Color(0xFFFEF3C7), 'accent': Color(0xFFD97706)},
    'Viernes':   {'bg': Color(0xFFFEE2E2), 'accent': Color(0xFFDC2626)},
    'Sabado':    {'bg': Color(0xFFFCE7F3), 'accent': Color(0xFFDB2777)},
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
              offset: const Offset(0, 2))
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
                  decoration: BoxDecoration(
                      color: accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Text(dia,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: accent)),
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
                    style:
                        TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          // Filas de clases
          ...clases.asMap().entries.map((entry) => _ClaseRow(
                clase: entry.value,
                accentColor: accent,
                isLast: entry.key == clases.length - 1,
              )),
        ],
      ),
    );
  }
}

// ── Fila de cada clase ────────────────────────────────────────────────────────
class _ClaseRow extends StatelessWidget {
  final Asignacion clase;
  final Color accentColor;
  final bool isLast;

  const _ClaseRow({
    required this.clase,
    required this.accentColor,
    required this.isLast,
  });

  String _fmt(String? t) => t?.substring(0, 5) ?? '--:--'; // "09:00:00" → "09:00"

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
          // Bloque de horas
          SizedBox(
            width: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_fmt(clase.horaInicio),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.arrow_downward_rounded,
                      size: 10, color: Colors.grey[400]),
                  const SizedBox(width: 2),
                  Text(_fmt(clase.horaFin),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF))),
                ]),
              ],
            ),
          ),
          // Línea vertical de acento
          Container(
            width: 3,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Materia + curso
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clase.materia ?? '',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.class_outlined,
                      size: 12, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(
                    '${clase.curso ?? ''} · Paralelo ${clase.paralelo ?? ''}',
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