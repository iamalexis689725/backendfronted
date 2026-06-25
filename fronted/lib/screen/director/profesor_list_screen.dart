import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profesor_viewmodel.dart';
 
class ProfesorListScreen extends StatefulWidget {
  const ProfesorListScreen({super.key});
 
  @override
  State<ProfesorListScreen> createState() => _ProfesorListScreenState();
}
 
class _ProfesorListScreenState extends State<ProfesorListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfesorViewModel>(context, listen: false).loadProfesores());
  }
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfesorViewModel>(context);
 
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async { context.go('/profesores/create');},
         
        child: const Icon(Icons.add),
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
          : vm.profesores.isEmpty
              ? const Center(child: Text('No hay profesores'))
              : ListView.builder(
                  itemCount: vm.profesores.length,
                  itemBuilder: (_, i) {
                    final p = vm.profesores[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(p.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.email ?? ''),
                            if (p.especialidad != null)
                              Text(p.especialidad!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.orange,
      ),
      tooltip: 'Editar profesor',
      onPressed: () {
        context.go(
          '/profesores/${p.id}/edit',
        );
      },
    ),

                             IconButton(
                             icon: const Icon(Icons.calendar_view_week_rounded,
                           color: Colors.deepPurple),
                            tooltip: 'Ver horario',
                        onPressed: () => context.go('/profesores/${p.id}/ver-horario',
      ),
    ),
                            // 📚 Asignar materia
                            IconButton(
                              icon: const Icon(Icons.menu_book, color: Colors.blue),
                              tooltip: 'Asignar materia',
                              onPressed: () async {
                                context.go(
                                  '/profesores/${p.id}/materia',
                                );
                              },
                            ),
                            // 🗓 Asignar horario
                            IconButton(
                              icon: const Icon(Icons.schedule, color: Colors.green),
                              tooltip: 'Asignar horario',
                              onPressed: () => context.go( 
                                '/profesores/${p.id}/horario' ,
                              ),
                            ),
                            // 🗑 Eliminar
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Eliminar profesor',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('¿Eliminar profesor?'),
                                    content: Text('Se eliminará a "${p.name}" permanentemente.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => context.pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: () => context.pop(true),
                                        child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true && mounted) {
                                  final ok = await vm.deleteProfesor(p.id!);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(ok ? 'Profesor eliminado' : 'Error al eliminar')));
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