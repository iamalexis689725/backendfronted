import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/circular_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class CircularListScreen extends StatefulWidget {
  const CircularListScreen({super.key});

  @override
  State<CircularListScreen> createState() => _CircularListScreenState();
}

class _CircularListScreenState extends State<CircularListScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CircularViewModel>().loadCirculares();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CircularViewModel>();
    final auth = context.watch<AuthViewModel>();

    final isDirector = auth.role == 'director';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      floatingActionButton: isDirector
          ? FloatingActionButton(
              backgroundColor: _purple,
              onPressed: () => context.go('/circulares/create'),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

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
          : vm.circulares.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: vm.loadCirculares,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: vm.circulares.length,
                    itemBuilder: (_, i) {
                      final circular = vm.circulares[i];

                      return _buildCard(
                        context,
                        vm,
                        auth,
                        circular,
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    CircularViewModel vm,
    AuthViewModel auth,
    dynamic circular,
  ) {
    final isDirector = auth.role == 'director';
    final leido = circular.leido ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
  borderRadius: BorderRadius.circular(14),

  onTap: isDirector
      ? null
      : (){
          context.go('/circulares/${circular.id}');
        },


        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICONO
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: leido
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  leido
                      ? Icons.mark_email_read_outlined
                      : Icons.email_outlined,
                  color: leido ? Colors.grey : _purple,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // TEXTO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            circular.titulo ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: leido
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        _TargetChip(
                          target: circular.target ?? '',
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      circular.contenido ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    if (circular.creadoPor != null) ...[
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              circular.creadoPor!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // BOTÓN ELIMINAR
              if (isDirector)
                IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () =>
                      _confirmarEliminar(context, vm, circular),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarEliminar(
    BuildContext context,
    CircularViewModel vm,
    dynamic circular,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('¿Eliminar circular?'),
          content: Text(
            'Se eliminará "${circular.titulo}" permanentemente.',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => context.pop(true),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final ok = await vm.deleteCircular(circular.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'Circular eliminada'
                : (vm.error ?? 'Error al eliminar')
          ),
        ),
      );
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay circulares',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Las circulares aparecerán aquí',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetChip extends StatelessWidget {
  final String target;

  const _TargetChip({
    required this.target,
  });

  static const _map = {
    'all': (
      'Todos',
      Color(0xFFEDE9FE),
      Color(0xFF4F46E5),
    ),
    'padres': (
      'Padres',
      Color(0xFFDBEAFE),
      Color(0xFF2563EB),
    ),
    'profesores': (
      'Profesores',
      Color(0xFFD1FAE5),
      Color(0xFF059669),
    ),
    'estudiantes': (
      'Estudiantes',
      Color(0xFFFEF3C7),
      Color(0xFFD97706),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final info =
        _map[target] ??
        ('?', const Color(0xFFF3F4F6), Colors.grey);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: info.$2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        info.$1,
        style: TextStyle(
          fontSize: 10,
          color: info.$3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}