import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profesor_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';

class ProfesorCreateScreen extends StatefulWidget {
  const ProfesorCreateScreen({super.key});

  @override
  State<ProfesorCreateScreen> createState() => _ProfesorCreateScreenState();
}

class _ProfesorCreateScreenState extends State<ProfesorCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codigoController = TextEditingController();
  final especialidadController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    codigoController.dispose();
    especialidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfesorViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Profesor')),

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
                    const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Crear Profesor',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    AuthInput(
                      controller: nameController,
                      label: 'Nombre',
                      icon: Icons.person,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscure: true,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: codigoController,
                      label: 'Código Profesor',
                      icon: Icons.badge,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: especialidadController,
                      label: 'Especialidad',
                      icon: Icons.book,
                      validator: (_) => null,
                    ),

                    // 🔥 ERROR DEL VM
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
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                FocusScope.of(context).unfocus();

                                final success =
                                    await vm.createProfesor(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password:
                                      passwordController.text.trim(),
                                  codigo:
                                      codigoController.text.trim(),
                                  especialidad:
                                      especialidadController
                                              .text
                                              .trim()
                                              .isEmpty
                                          ? null
                                          : especialidadController.text
                                              .trim(),
                                );

                                if (!mounted) return;

                                if (success) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profesor creado correctamente',
                                      ),
                                    ),
                                  );

                                  context.go('/profesores');
                                }
                              },

                        child: vm.creating
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Crear Profesor'),
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