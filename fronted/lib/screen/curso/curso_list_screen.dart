import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/curso_viewmodel.dart';
 
class CursoListScreen extends StatefulWidget {
  const CursoListScreen({super.key});
 
  @override
  State<CursoListScreen> createState() => _CursoListScreenState();
}
 
class _CursoListScreenState extends State<CursoListScreen> {
  static const _purple = Color(0xFF4F46E5);
 
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CursoViewModel>(context, listen: false).loadCursos());
  }
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CursoViewModel>(context);
 
    if (!vm.loading && vm.errorPeriodo != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(vm.errorPeriodo!, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                onPressed: () => vm.loadCursos(),
              ),
            ],
          ),
        ),
      );
    }
 
    return Scaffold(
      floatingActionButton: vm.periodoActivo == null
          ? null
          : FloatingActionButton(
              backgroundColor: _purple,
              onPressed: () async {context.go('/cursos/create');},
               /*  await context.push('/cursos/nuevo'); // 🔥
                if (mounted) vm.loadCursos();
              }, */
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: Column(
        children: [
          if (vm.periodoActivo != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: _purple, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Periodo activo: ${vm.periodoActivo!.nombre ?? ''}',
                      style: const TextStyle(color: _purple, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: vm.loading
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
                : vm.cursos.isEmpty
                    ? const Center(child: Text('No hay cursos en este periodo'))
                    : ListView.builder(
                        itemCount: vm.cursos.length,
                        itemBuilder: (_, i) {
                          final c = vm.cursos[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFD1FAE5),
                                child: Icon(Icons.class_, color: Color(0xFF059669)),
                              ),
                              title: Text(c.nombre ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.nivel ?? ''),
                                  if (c.descripcion != null && c.descripcion!.isNotEmpty)
                                    Text(c.descripcion!,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 🔵 Ver paralelos
                                  IconButton(
                                    icon: const Icon(Icons.account_tree, color: Colors.blue),
                                    tooltip: 'Ver paralelos',
                                    onPressed: () => context.go(  // 🔥
                                      '/cursos/${c.id}/paralelos',
                                      /* extra: {
                                        'curso':     c,
                                        'periodoId': vm.periodoActivo!.id!,
                                      }, */
                                    ),
                                  ),
                                  // 🔴 Eliminar
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('¿Eliminar curso?'),
                                          content: Text('Se eliminará "${c.nombre}" permanentemente.'),
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
                                      if (confirm == true && mounted) {
                                        final ok = await vm.deleteCurso(c.id!);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(ok ? 'Curso eliminado' : 'Error al eliminar')));
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
          ),
        ],
      ),
    );
  }
}