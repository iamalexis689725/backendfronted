import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/padre_familia_viewmodel.dart';

class MisHijosScreen extends StatefulWidget {
  const MisHijosScreen({super.key});

  @override
  State<MisHijosScreen> createState() => _MisHijosScreenState();
}

class _MisHijosScreenState extends State<MisHijosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PadreFamiliaViewModel>().loadMisHijos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PadreFamiliaViewModel>();

    if (vm.loading){ return const Center(child: CircularProgressIndicator());}
    if (vm.error != null){ return Center(child: Text(vm.error!)); }
    if (vm.misHijos.isEmpty){ return const Center(
      child: Text("No tienes estudiantes asignados", style: TextStyle(fontSize: 16)),
    ); }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: vm.misHijos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (_, index) {
        final hijo = vm.misHijos[index];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.go('/mis-hijos/${hijo.id}'),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.school, color: Color(0xFF4F46E5), size: 30),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hijo.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("Código: ${hijo.codigoEstudiante}", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 3),
                      Text("Parentesco: ${hijo.parentesco}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}