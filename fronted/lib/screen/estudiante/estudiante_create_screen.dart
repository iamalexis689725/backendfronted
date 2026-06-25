import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/estudiante_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
import 'package:go_router/go_router.dart';

class EstudianteCreateScreen extends StatefulWidget {
  const EstudianteCreateScreen({super.key});

  @override
  State<EstudianteCreateScreen> createState() =>
      _EstudianteCreateScreenState();
}

class _EstudianteCreateScreenState extends State<EstudianteCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EstudianteViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Estudiante')),
      body: Center(
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: AuthCard(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school, size: 60, color: Colors.blue),
              const SizedBox(height: 10),
              const Text(
                'Crear Estudiante',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              AuthInput(
                controller: nameController,
                label: 'Nombre',
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              AuthInput(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              AuthInput(
                controller: passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                obscure: true,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              AuthInput(
                controller: codigoController,
                label: 'Código Estudiante',
                icon: Icons.badge,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
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
                  onPressed: vm.creating
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          FocusScope.of(context).unfocus();

                          final success = await vm.createEstudiante(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            codigo: codigoController.text.trim(),
                          );

                          if (!mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Estudiante creado correctamente'),
                              ),
                            );

                            context.go('/estudiantes');
                          } /* else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al crear')),
                            );
                          } */
                        },
                  child: vm.creating
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Crear Estudiante'),
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