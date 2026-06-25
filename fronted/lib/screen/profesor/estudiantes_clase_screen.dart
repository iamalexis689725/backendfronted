import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/estudiantes_clase_viewmodel.dart';
import '../../models/estudiante_clase.dart';

class EstudiantesClaseScreen extends StatefulWidget {
  final int    periodoId;
  final int    cursoId;
  final int    paraleloId;
  final String cursoNombre;    
  final String paraleloNombre;

  const EstudiantesClaseScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.cursoNombre,
    required this.paraleloNombre,
  });

  @override
  State<EstudiantesClaseScreen> createState() => _EstudiantesClaseScreenState();
}

class _EstudiantesClaseScreenState extends State<EstudiantesClaseScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<EstudiantesClaseViewModel>().load(
          periodoId:  widget.periodoId,
          cursoId:    widget.cursoId,
          paraleloId: widget.paraleloId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstudiantesClaseViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.cursoNombre} · ${widget.paraleloNombre}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const Text(
              'Lista de estudiantes',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar',
            onPressed: vm.loading ? null : () => vm.reload(),
          ),
        ],
      ),

      body: Builder(builder: (_) {
        // ── Estado de carga ──────────────────────────────────────
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ────────────────────────────────────────────────
        if (vm.error != null) {
          return _ErrorState(
            message: vm.error!,
            onRetry: () => vm.reload(),
          );
        }

        // ── Sin estudiantes ──────────────────────────────────────
        if (vm.estudiantes.isEmpty) {
          return _EmptyState(onRetry: () => vm.reload());
        }

        // ── Lista ────────────────────────────────────────────────
        return Column(
          children: [
            _buildHeader(vm.estudiantes.length),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: vm.estudiantes.length,
                itemBuilder: (_, i) =>
                    _EstudianteCard(estudiante: vm.estudiantes[i], index: i + 1),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(int total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.group_outlined, color: _purple, size: 18),
          const SizedBox(width: 10),
          Text(
            '$total ${total == 1 ? 'estudiante inscrito' : 'estudiantes inscritos'}',
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

// ── Tarjeta individual ────────────────────────────────────────────────────────
class _EstudianteCard extends StatelessWidget {
  final EstudianteClase estudiante;
  final int             index;

  const _EstudianteCard({required this.estudiante, required this.index});

  static const _purple = Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    final initials = _initials(estudiante.nombre ?? '?');

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _purple.withOpacity(.12),
          child: Text(
            initials,
            style: const TextStyle(
              color: _purple,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          estudiante.nombre ?? 'Sin nombre',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          estudiante.email ?? '',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '#$index',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF059669),
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }
}

// ── Estados vacío y error ─────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off_outlined, size: 64, color: Colors.grey[350]),
          const SizedBox(height: 16),
          const Text('No hay estudiantes inscritos',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Aún no hay alumnos asignados a este paralelo',
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

