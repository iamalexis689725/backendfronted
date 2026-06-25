import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/periodo_evaluacion_viewmodel.dart';
import '../../core/widgest/app/app_card.dart';
import '../../core/widgest/app/app_input.dart';

class PeriodoEvaluacionCreateScreen
    extends StatefulWidget {

  final int periodoId;

  const PeriodoEvaluacionCreateScreen({
    super.key,
    required this.periodoId,
  });

  @override
  State<PeriodoEvaluacionCreateScreen>
      createState() =>
          _PeriodoEvaluacionCreateScreenState();
}

class _PeriodoEvaluacionCreateScreenState
    extends State<PeriodoEvaluacionCreateScreen> {

  final _formKey = GlobalKey<FormState>();

  final nombreController =
      TextEditingController();

  final ordenController =
      TextEditingController();

  @override
  void dispose() {

    nombreController.dispose();
    ordenController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<PeriodoEvaluacionViewModel>();

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          'Nuevo Periodo de Evaluación',
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: ConstrainedBox(
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Crear Periodo de Evaluación',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    AppInput(
                      controller:
                          nombreController,
                      label: 'Nombre',
                      icon:
                          Icons.assignment,
                      validator: (v) {
                        if (v == null ||
                            v.isEmpty) {
                          return 'Campo requerido';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    AppInput(
                      controller:
                          ordenController,
                      label: 'Orden',
                      icon:
                          Icons.format_list_numbered,
                      keyboardType:
                          TextInputType.number,
                      validator: (v) {

                        if (v == null ||
                            v.isEmpty) {
                          return 'Campo requerido';
                        }

                        if (int.tryParse(v) ==
                            null) {
                          return 'Ingrese un número';
                        }

                        return null;
                      },
                    ),

                    if (vm.error != null) ...[

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        vm.error!,
                        style:
                            const TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(
                      height: 30,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      child:
                          ElevatedButton(
                        onPressed:
                            vm.creating
                                ? null
                                : () async {

                                    if (!_formKey
                                        .currentState!
                                        .validate()) {
                                      return;
                                    }

                                    FocusScope.of(
                                            context)
                                        .unfocus();

                                    final success =
                                        await vm
                                            .createPeriodoEvaluacion(
                                      periodoId:
                                          widget
                                              .periodoId,
                                      nombre:
                                          nombreController
                                              .text
                                              .trim(),
                                      orden: int.parse(
                                        ordenController
                                            .text,
                                      ),
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (success) {

                                      ScaffoldMessenger
                                              .of(
                                                  context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Periodo de evaluación creado correctamente',
                                          ),
                                        ),
                                      );

                                      context.go(
                                        '/periodos/${widget.periodoId}/periodos-evaluacion',
                                      );
                                    }
                                  },

                        child: vm.creating
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                ),
                              )
                            : const Text(
                                'Guardar',
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