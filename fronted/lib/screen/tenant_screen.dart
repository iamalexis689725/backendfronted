import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/tenant_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';

class TenantScreen extends StatefulWidget {
  const TenantScreen({super.key});

  @override
  State<TenantScreen> createState() => _TenantScreenState();
}

class _TenantScreenState extends State<TenantScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final slugController = TextEditingController();
  final directorNameController = TextEditingController();
  final directorEmailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    slugController.dispose();
    directorNameController.dispose();
    directorEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TenantViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Crear Colegio'),
      ),

      body: Center(
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
                      Icons.school,
                      size: 60,
                      color: Colors.indigo,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Crear Colegio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (vm.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          vm.error!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),

                    AuthInput(
                      controller: nameController,
                      label: 'Nombre colegio',
                      icon: Icons.school,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: slugController,
                      label: 'Slug',
                      icon: Icons.link,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: directorNameController,
                      label: 'Nombre director',
                      icon: Icons.person,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Campo requerido'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: directorEmailController,
                      label: 'Email director',
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

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.creating
                            ? null
                            : () async {

                            /*     if (!_formKey.currentState!.validate()) {
                                  return;
                                }
 */
                                FocusScope.of(context).unfocus();

                                final success =
                                    await vm.createTenant(
                                  name: nameController.text.trim(),
                                  slug: slugController.text.trim(),
                                  directorName:
                                      directorNameController.text.trim(),
                                  directorEmail:
                                      directorEmailController.text.trim(),
                                  password:
                                      passwordController.text.trim(),
                                );

                                if (!mounted) return;

                                if (success) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Colegio creado correctamente',
                                      ),
                                    ),
                                  );

                                  context.go('/colegios');

                                } else {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        vm.error ??
                                            'Error al crear colegio',
                                      ),
                                    ),
                                  );
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
                            : const Text('Crear Colegio'),
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