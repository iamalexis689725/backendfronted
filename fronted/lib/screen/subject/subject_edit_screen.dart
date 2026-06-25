import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/widgest/app/app_card.dart';
import '../../core/widgest/app/app_input.dart';
import '../../viewmodels/subject_repository.dart';

class SubjectEditScreen extends StatefulWidget {
  final int id;

  const SubjectEditScreen({
    super.key,
    required this.id,
  });

  @override
  State<SubjectEditScreen> createState() =>
      _SubjectEditScreenState();
}

class _SubjectEditScreenState
    extends State<SubjectEditScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    cargarMateria();
  }

  Future<void> cargarMateria() async {

    final vm =
        context.read<SubjectViewModel>();

    final subject =
        await vm.getSubjectById(widget.id);

    if (subject != null) {

      nameController.text =
          subject.name ?? '';
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<SubjectViewModel>();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          "Editar Materia",
        ),
      ),

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

                  child: AppCard(

                    child: Form(

                      key: _formKey,

                      child: Column(

                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          const Icon(
                            Icons.menu_book,
                            size: 60,
                            color: Colors.blue,
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          AppInput(
                            controller:
                                nameController,

                            label:
                                "Nombre de la materia",

                            icon: Icons.menu_book,

                            validator:
                                (v) =>
                                    v!.isEmpty
                                        ? "Campo requerido"
                                        : null,
                          ),

                          if (vm.error !=
                              null) ...[

                            const SizedBox(
                              height: 10,
                            ),

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
                            height: 25,
                          ),

                          SizedBox(

                            width:
                                double.infinity,

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
                                              await vm
                                                  .updateSubject(

                                            id: widget.id,

                                            name:
                                                nameController
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

                                                content:
                                                    Text(
                                                  "Materia actualizada correctamente",
                                                ),
                                              ),
                                            );

                                            context.go(
                                              "/materias",
                                            );
                                          }
                                        },

                              child:
                                  vm.updating

                                      ? const SizedBox(

                                          height: 20,
                                          width: 20,

                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth:
                                                2,
                                            color: Colors
                                                .white,
                                          ),
                                        )

                                      : const Text(
                                          "Actualizar Materia",
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