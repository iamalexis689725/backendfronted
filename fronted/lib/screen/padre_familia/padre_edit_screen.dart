import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
import '../../viewmodels/padre_familia_viewmodel.dart';

class PadreEditScreen extends StatefulWidget {

  final int id;

  const PadreEditScreen({
    super.key,
    required this.id,
  });

  @override
  State<PadreEditScreen> createState() =>
      _PadreEditScreenState();
}

class _PadreEditScreenState
    extends State<PadreEditScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController =
      TextEditingController();

  final telefonoController =
      TextEditingController();

  final ocupacionController =
      TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    cargarPadre();
  }

  Future<void> cargarPadre() async {

    final vm = context.read<PadreFamiliaViewModel>();

    final padre =
        await vm.getPadreById(widget.id);

    if (padre != null) {

      nameController.text =
          padre.name ?? '';

      emailController.text =
          padre.email ?? '';

      telefonoController.text =
          padre.telefono ?? '';

      ocupacionController.text =
          padre.ocupacion ?? '';
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<PadreFamiliaViewModel>();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FB),
     appBar: AppBar(title: const Text('Editar Padre de Familia')),
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
                            Icons.family_restroom,
                            size: 60,
                            color:
                                Colors.deepPurple,
                          ),

                          const SizedBox(
                              height: 10),

                          const Text(
                            "Editar Padre de Familia",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          AuthInput(
                            controller:
                                nameController,
                            label:
                                "Nombre",
                            icon: Icons
                                .person,
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
                            icon: Icons
                                .email,
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
                                telefonoController,
                            label:
                                "Teléfono",
                            icon: Icons
                                .phone,
                            validator:
                                (_) =>
                                    null,
                          ),

                          const SizedBox(
                              height: 16),

                          AuthInput(
                            controller:
                                ocupacionController,
                            label:
                                "Ocupación",
                            icon:
                                Icons.work,
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
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],

                          const SizedBox(
                              height: 20),

                          SizedBox(
                            width: double
                                .infinity,
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
                                              await vm.updatePadre(

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

                                            telefono:
                                                telefonoController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? null
                                                    : telefonoController
                                                        .text
                                                        .trim(),

                                            ocupacion:
                                                ocupacionController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? null
                                                    : ocupacionController
                                                        .text
                                                        .trim(),
                                          );

                                          if (!mounted)
                                            return;

                                          if (success) {

                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text(
                                                  "Padre actualizado correctamente",
                                                ),
                                              ),
                                            );

                                            context.go(
                                                "/padres");
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
                                            color: Colors
                                                .white,
                                          ),
                                        )

                                      : const Text(
                                          "Actualizar Padre",
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