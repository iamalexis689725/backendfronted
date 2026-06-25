import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/padre_familia_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
import 'package:go_router/go_router.dart';

class PadreCreateScreen extends StatefulWidget {
  const PadreCreateScreen({super.key});

  @override
  State<PadreCreateScreen> createState() => _PadreCreateScreenState();
}

class _PadreCreateScreenState extends State<PadreCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final telefonoController = TextEditingController();
  final ocupacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PadreFamiliaViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Padre de Familia')),
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
                    const Icon(Icons.family_restroom,
                        size: 60, color: Colors.deepPurple),
                    const SizedBox(height: 10),
                    const Text(
                      'Crear Padre de Familia',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      controller: nameController,
                      label: 'Nombre',
                      icon: Icons.person,
                      validator: (v) =>
                          v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      validator: (v) =>
                          v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscure: true,
                      validator: (v) =>
                          v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: telefonoController,
                      label: 'Teléfono',
                      icon: Icons.phone,
                      validator: (_) => null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: ocupacionController,
                      label: 'Ocupación',
                      icon: Icons.work,
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
                        // 🔥 USAMOS creating
                        onPressed: vm.creating
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                FocusScope.of(context).unfocus(); // UX

                                final success = await vm.createPadre(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password:
                                      passwordController.text.trim(),
                                  telefono:
                                      telefonoController.text.isEmpty
                                          ? null
                                          : telefonoController.text,
                                  ocupacion:
                                      ocupacionController.text.isEmpty
                                          ? null
                                          : ocupacionController.text,
                                );

                                if (!mounted) return;

                                if (success) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Padre creado correctamente'),
                                    ),
                                  );

                                  context.go('/padres');
                                } /* else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('Error al crear'),
                                    ),
                                  );
                                } */
                              },

                        // 🔥 LOADER SOLO EN BOTÓN
                        child: vm.creating
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Crear Padre'),
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