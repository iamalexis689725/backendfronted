import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/paralelo_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';

class ParaleloCreateScreen extends StatefulWidget {
  final int cursoId;

  const ParaleloCreateScreen({
    super.key,
    required this.cursoId,
  });

  @override
  State<ParaleloCreateScreen> createState() => _ParaleloCreateScreenState();
}

class _ParaleloCreateScreenState extends State<ParaleloCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final turnoController = TextEditingController();
  final capacidadController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    turnoController.dispose();
    capacidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParaleloViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text('Crear Paralelo'),
      ),

      body: vm.creating
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: AuthCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.account_tree,
                            size: 60,
                            color: Colors.blue,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Crear Paralelo',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          AuthInput(
                            controller: nombreController,
                            label: 'Nombre (A, B, C...)',
                            icon: Icons.label,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Campo requerido' : null,
                          ),

                          const SizedBox(height: 16),

                          AuthInput(
                            controller: turnoController,
                            label: 'Turno',
                            icon: Icons.schedule,
                            validator: (_) => null,
                          ),

                          const SizedBox(height: 16),

                          AuthInput(
                            controller: capacidadController,
                            label: 'Capacidad',
                            icon: Icons.people,
                            validator: (_) => null,
                          ),
                          if (vm.error != null) ...[
  const SizedBox(height: 10),

  Text(
    vm.error!,
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w600,
    ),
  ),
],

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final vmParalelo =
                                    context.read<ParaleloViewModel>();

                                final success =
                                    await vmParalelo.createParalelo(
                                  cursoId: widget.cursoId,
                                  nombre: nombreController.text.trim(),
                                  turno: turnoController.text.trim().isEmpty
                                      ? null
                                      : turnoController.text.trim(),
                                  capacidad:
                                      capacidadController.text.trim().isEmpty
                                          ? null
                                          : int.tryParse(
                                              capacidadController.text.trim(),
                                            ),
                                );

                                if (!mounted) return;

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Paralelo creado correctamente',
                                      ),
                                    ),
                                  );

                                  // 🔥 solo navegar, la lista ya se actualiza con add()
                                  context.go(
                                    '/cursos/${widget.cursoId}/paralelos',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                      content: Text(vm.error ?? 'Error al crear'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Crear Paralelo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}