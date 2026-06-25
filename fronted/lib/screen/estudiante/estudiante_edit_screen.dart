import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
import '../../viewmodels/estudiante_viewmodel.dart';

class EstudianteEditScreen extends StatefulWidget {
  final int id;

  const EstudianteEditScreen({
    super.key,
    required this.id,
  });

  @override
  State<EstudianteEditScreen> createState() =>
      _EstudianteEditScreenState();
}

class _EstudianteEditScreenState
    extends State<EstudianteEditScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codigoController = TextEditingController();

  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loaded) {
      loaded = true;

      Future.microtask(() async {

        final vm =
            context.read<EstudianteViewModel>();

        final estudiante =
            await vm.getEstudiante(widget.id);

        if (estudiante != null) {

          nameController.text =
              estudiante.name ?? '';

          emailController.text =
              estudiante.email ?? '';

          codigoController.text =
              estudiante.codigoEstudiante ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<EstudianteViewModel>();

    return Scaffold(

      backgroundColor: const Color( 0xFFF5F7FB,),
      appBar: AppBar(title: const Text('Editar Estudiante')),
      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 400,
            ),

            child: AuthCard(

              child: Form(

                key: _formKey,

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    const Icon(
                      Icons.edit,
                      size: 60,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Editar Estudiante",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    AuthInput(
                      controller: nameController,
                      label: "Nombre",
                      icon: Icons.person,
                      validator: (v) =>
                          v!.isEmpty
                              ? "Campo requerido"
                              : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email,
                      validator: (v) =>
                          v!.isEmpty
                              ? "Campo requerido"
                              : null,
                    ),

                    const SizedBox(height: 16),

                   AuthInput(
                      controller: passwordController,
                      label: "Nueva contraseña (opcional)",
                      icon: Icons.lock,
                      obscure: true,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: codigoController,
                      label:
                          "Código estudiante",
                      icon: Icons.badge,
                      validator: (v) =>
                          v!.isEmpty
                              ? "Campo requerido"
                              : null,
                    ),

                    if (vm.error != null) ...[
                      const SizedBox(height: 10),

                      Text(
                        vm.error!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    SizedBox(

                      width: double.infinity,

                      child: ElevatedButton(

                        onPressed: () async {

                          if (!_formKey.currentState!
                              .validate()) {
                            return;
                          }

                          final success =
                              await vm.updateEstudiante(

                            id: widget.id,

                            name:
                                nameController.text.trim(),

                            email:
                                emailController.text.trim(),

                            password:
                                passwordController.text.trim(),

                            codigo:
                                codigoController.text.trim(),
                          );

                          if (!mounted) return;

                          if (success) {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(

                              const SnackBar(
                                content: Text(
                                  "Estudiante actualizado correctamente",
                                ),
                              ),
                            );

                            context.go(
                              "/estudiantes",
                            );
                          }
                        },

                        child: const Text(
                          "Actualizar Estudiante",
                        ),
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