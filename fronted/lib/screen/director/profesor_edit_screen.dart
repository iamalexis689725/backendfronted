import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
import '../../viewmodels/profesor_viewmodel.dart';

class ProfesorEditScreen extends StatefulWidget {
  final int id;

  const ProfesorEditScreen({
    super.key,
    required this.id,
  });

  @override
  State<ProfesorEditScreen> createState() =>
      _ProfesorEditScreenState();
}

class _ProfesorEditScreenState
    extends State<ProfesorEditScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController =
      TextEditingController();

  final codigoController =
      TextEditingController();

  final especialidadController =
      TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    cargarProfesor();
  }

  Future<void> cargarProfesor() async {

    final vm = context.read<ProfesorViewModel>();

    final profesor =
        await vm.getProfesorById(widget.id);

    if (profesor != null) {

      nameController.text =
          profesor.name ?? '';

      emailController.text =
          profesor.email ?? '';

      codigoController.text =
          profesor.codigo ?? '';

      especialidadController.text =
          profesor.especialidad ?? '';
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<ProfesorViewModel>();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Editar Profesor')),
      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Center(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                        20),
                child:
                    ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: AuthCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [

                          const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blue,
                          ),

                          const SizedBox(
                              height: 10),

                          const Text(
                            "Editar Profesor",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          AuthInput(
                            controller:
                                nameController,
                            label:
                                "Nombre",
                            icon: Icons.person,
                            validator:
                                (v) =>
                                    v!
                                            .isEmpty
                                        ? "Campo requerido"
                                        : null,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthInput(
                            controller:
                                emailController,
                            label:
                                "Email",
                            icon: Icons.email,
                            validator:
                                (v) =>
                                    v!
                                            .isEmpty
                                        ? "Campo requerido"
                                        : null,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthInput(
                            controller:
                                passwordController,
                            label:
                                "Nueva contraseña (opcional)",
                            icon:
                                Icons.lock,
                            obscure:
                                true,
                            validator:
                                (_) =>
                                    null,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthInput(
                            controller:
                                codigoController,
                            label:
                                "Código Profesor",
                            icon:
                                Icons.badge,
                            validator:
                                (v) =>
                                    v!
                                            .isEmpty
                                        ? "Campo requerido"
                                        : null,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthInput(
                            controller:
                                especialidadController,
                            label:
                                "Especialidad",
                            icon:
                                Icons.book,
                            validator:
                                (_) =>
                                    null,
                          ),

                          if (vm.error !=
                              null) ...[
                            const SizedBox(
                                height:
                                    10),

                            Text(
                              vm.error!,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.red,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],

                          const SizedBox(
                              height: 20),

                          SizedBox(
                            width: double.infinity,
                            child:
                                ElevatedButton(

                              onPressed:
                                  vm.updating
                                      ? null
                                      : () async {

                                          if (!_formKey
                                              .currentState!
                                              .validate()) {
                                            return;
                                          }

                                          final success =
                                              await vm.updateProfesor(

                                            id: widget.id,

                                            name:
                                                nameController
                                                    .text
                                                    .trim(),

                                            email:
                                                emailController
                                                    .text
                                                    .trim(),

                                            password:
                                                passwordController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? null
                                                    : passwordController
                                                        .text
                                                        .trim(),

                                            codigo:
                                                codigoController
                                                    .text
                                                    .trim(),

                                            especialidad:
                                                especialidadController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? null
                                                    : especialidadController
                                                        .text
                                                        .trim(),
                                          );

                                          if (!mounted) {
                                            return;
                                          }

                                          if (success) {

                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Profesor actualizado correctamente",
                                                ),
                                              ),
                                            );

                                            context.go(
                                              "/profesores",
                                            );
                                          }
                                        },

                              child:
                                  vm.updating

                                      ? const SizedBox(
                                          width:
                                              20,
                                          height:
                                              20,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth:
                                                2,
                                            color:
                                                Colors.white,
                                          ),
                                        )

                                      : const Text(
                                          "Actualizar Profesor",
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