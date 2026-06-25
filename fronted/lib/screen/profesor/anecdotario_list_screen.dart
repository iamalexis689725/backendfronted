import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/anecdotario_viewmodel.dart';

class AnecdotarioListScreen extends StatefulWidget {
  final int asignacionId;
  final int periodoId;

  const AnecdotarioListScreen({
    super.key,
    required this.asignacionId,
    required this.periodoId,
  });

  @override
  State<AnecdotarioListScreen> createState() =>
      _AnecdotarioListScreenState();
}

class _AnecdotarioListScreenState
    extends State<AnecdotarioListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AnecdotarioViewModel>()
        .loadAnecdotarios(
          asignacionDocenteId: widget.asignacionId,
          academicPeriodId: widget.periodoId,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnecdotarioViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anecdotarios'),
      ),
      body: vm.loading
          ? const Center(
               child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: vm.anecdotarios.length,
              itemBuilder: (_, i) {
                final a = vm.anecdotarios[i];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(a.titulo ?? ''),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(a.estudiante ?? ''),
                        Text(a.descripcion ?? ''),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(label: Text(a.tipo ?? '')),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, vm, a.id ?? 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    AnecdotarioViewModel vm,
    int anecdotarioId,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Eliminar anecdotario'),
          content: const Text('¿Estás seguro de que deseas eliminar este anecdotario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final success = await vm.deleteAnecdotario(
        anecdotarioId: anecdotarioId,
      );
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anecdotario eliminado')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(vm.error ?? 'Error al eliminar')),
          );
        }
      }
    }
  }
}