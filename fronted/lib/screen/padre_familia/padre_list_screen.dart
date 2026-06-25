import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/padre_familia_viewmodel.dart';

class PadreListScreen extends StatefulWidget {
  const PadreListScreen({super.key});

  @override
  State<PadreListScreen> createState() => _PadreListScreenState();
}

class _PadreListScreenState extends State<PadreListScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PadreFamiliaViewModel>().loadPadres());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PadreFamiliaViewModel>();

    return Scaffold(
      // 🔥 FAB con go() (URL SI cambia)
      floatingActionButton: FloatingActionButton(
        onPressed: () {context.go('/padres/create'); },
        child: const Icon(Icons.add),
      ),

      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.padres.isEmpty
              ? const Center(child: Text("No hay padres"))
              : ListView.builder(
                  itemCount: vm.padres.length,
                  itemBuilder: (_, i) {
                    final p = vm.padres[i];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),

                        leading: const CircleAvatar(
                          child: Icon(Icons.family_restroom),
                        ),

                        title: Text(
                          p.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.email ?? ''),
                            if (p.telefono != null)
                              Text('Tel: ${p.telefono}',
                                  style: const TextStyle(fontSize: 12)),
                            if (p.ocupacion != null)
                              Text(
                                p.ocupacion!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),

                       trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
  icon: const Icon(
    Icons.school,
    color: Colors.green,
  ),
  tooltip: "Asignar estudiante",
  onPressed: () {

    context.go(
      '/padres/${p.id}/estudiantes',
    );
  },
),

    // BOTÓN EDITAR
    IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      onPressed: () {
        context.go(
          '/padres/${p.id}/edit',
        );
      },
    ),

    // BOTÓN ELIMINAR
    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () async {

        final confirm =
            await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              '¿Eliminar padre?',
            ),
            content: Text(
              'Se eliminará a "${p.name}" permanentemente.',
            ),
            actions: [

              TextButton(
                onPressed: () =>
                    context.pop(false),
                child: const Text(
                  'Cancelar',
                ),
              ),

              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                ),
                onPressed: () =>
                    context.pop(true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );

        if (confirm == true && mounted) {

          final success =
              await vm.deletePadre(
            p.id!,
          );

          if (mounted) {

            ScaffoldMessenger.of(
                    context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Padre eliminado'
                      : 'Error al eliminar',
                ),
              ),
            );
          }
        }
      },
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