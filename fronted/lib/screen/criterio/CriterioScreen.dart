import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/criterio_viewmodel.dart';
import '../../viewmodels/periodo_evaluacion_viewmodel.dart';
import '../../models/periodo_evaluacion.dart';

class CriterioScreen extends StatefulWidget {
  final int asignacionId;
  final int periodoId;

  const CriterioScreen({
    super.key,
    required this.asignacionId,
    required this.periodoId,
  });

  @override
  State<CriterioScreen> createState() =>
      _CriterioScreenState();
}

class _CriterioScreenState
    extends State<CriterioScreen> {

  int? _criterioEditandoId;

  int? _periodoEvaluacionSeleccionado;
  bool get _editando =>
    _criterioEditandoId != null;
    
  final _formKey = GlobalKey<FormState>();

  final _nombreController =
      TextEditingController();

  final _porcentajeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context
          .read<PeriodoEvaluacionViewModel>()
          .loadPeriodosEvaluacion(
            widget.periodoId,
          );

      await context
          .read<CriterioViewModel>()
          .loadCriterios(
            widget.asignacionId,
          );
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _porcentajeController.dispose();
    super.dispose();
  }

  void _editar(criterio) {
    setState(() {
      _periodoEvaluacionSeleccionado =
    criterio.periodoEvaluacionId;

      _criterioEditandoId = criterio.id;

      _nombreController.text =
          criterio.nombre ?? '';

      _porcentajeController.text =
          criterio.porcentaje
                  ?.toStringAsFixed(0) ??
              '';
    });
  }

  void _cancelarEdicion() {
    setState(() {
      _criterioEditandoId = null;
    });

    _nombreController.clear();
    _porcentajeController.clear();
    _periodoEvaluacionSeleccionado = null;
    
  }
  

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vm =
        context.read<CriterioViewModel>();

    bool success;

    if (_editando) {
      success =
          await vm.actualizarCriterio(
        criterioId:
            _criterioEditandoId!,
        asignacionId:
            widget.asignacionId,
        nombre:
            _nombreController.text.trim(),
        porcentaje: double.parse(
          _porcentajeController.text,
        ),
      );
    } else {
      success =
    await vm.crearCriterio(
  asignacionId:
      widget.asignacionId,
  periodoEvaluacionId:
      _periodoEvaluacionSeleccionado!,
  nombre:
      _nombreController.text.trim(),
  porcentaje: double.parse(
    _porcentajeController.text,
  ),
);
    }

    if (!mounted) return;

    if (success) {
      final mensaje = _editando
          ? 'Criterio actualizado correctamente'
          : 'Criterio creado correctamente';

      _cancelarEdicion();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            vm.error ??
                'Ocurrió un error',
          ),
        ),
      );
    }
  }

  Future<void> _eliminar(int criterioId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar criterio'),
        content: const Text(
          '¿Desea eliminar este criterio?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final vm = context.read<CriterioViewModel>();

    try {
      await vm.eliminarCriterio(
        asignacionId: widget.asignacionId,
        criterioId: criterioId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Criterio eliminado correctamente',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        context.watch<CriterioViewModel>();

    final periodoVm =
        context.watch<PeriodoEvaluacionViewModel>();

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Criterios de Evaluación',
        ),
      ),
      body: vm.loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets
                              .all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              _editando
                                  ? 'Editar criterio'
                                  : 'Crear criterio',
                              style: const TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<int>(
  value: _periodoEvaluacionSeleccionado,
  decoration: const InputDecoration(
    labelText: 'Periodo de evaluación',
    border: OutlineInputBorder(),
  ),
  items: periodoVm.periodosEvaluacion
      .map(
        (periodo) => DropdownMenuItem(
          value: periodo.id,
          child: Text(periodo.nombre ?? ''),
        ),
      )
      .toList(),
  onChanged: (value) {
    setState(() {
      _periodoEvaluacionSeleccionado = value;
    });
  },
  validator: (value) {
    if (value == null) {
      return 'Seleccione un periodo';
    }
    return null;
  },
),
const SizedBox(height: 12),
                            TextFormField(
                              controller:
                                  _nombreController,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Nombre',
                                border:
                                    OutlineInputBorder(),
                              ),
                              validator:
                                  (v) {
                                if (v ==
                                        null ||
                                    v.trim()
                                        .isEmpty) {
                                  return 'Ingrese un nombre';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            TextFormField(
                              controller:
                                  _porcentajeController,
                              keyboardType:
                                  TextInputType
                                      .number,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Porcentaje',
                                border:
                                    OutlineInputBorder(),
                              ),
                              validator:
                                  (v) {
                                if (v ==
                                        null ||
                                    v.isEmpty) {
                                  return 'Ingrese un porcentaje';
                                }

                                final valor =
                                    double.tryParse(
                                  v,
                                );

                                if (valor ==
                                    null) {
                                  return 'Número inválido';
                                }

                                if (valor <
                                        1 ||
                                    valor >
                                        100) {
                                  return 'Debe estar entre 1 y 100';
                                }

                                return null;
                              },
                            ),

                            if (vm.error !=
                                null) ...[
                              const SizedBox(
                                height:
                                    12,
                              ),
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
                              height: 20,
                            ),

                            ElevatedButton(
                              onPressed:
                                  vm.creating
                                      ? null
                                      : _guardar,
                              child:
                                  vm.creating
                                      ? const SizedBox(
                                          height:
                                              18,
                                          width:
                                              18,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth:
                                                2,
                                          ),
                                        )
                                      : Text(
                                          _editando
                                              ? 'Actualizar'
                                              : 'Crear',
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  if (vm.criterios.isEmpty)
                    const Card(
                      child: Padding(
                        padding:
                            EdgeInsets.all(
                          20,
                        ),
                        child: Center(
                          child: Text(
                            'No hay criterios registrados',
                          ),
                        ),
                      ),
                    ),

                  ...vm.criterios.map(
                    (criterio) =>
                        Card(
                      margin:
                          const EdgeInsets
                              .only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        title: Text(
                          criterio.nombre ??
                              '',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      criterio.periodoEvaluacion?.nombre ?? '',
    ),
    Text(
      '${criterio.porcentaje?.toStringAsFixed(0)}%',
    ),
  ],
),
                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min,
                          children: [
                            ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors
                                        .amber,
                              ),
                              onPressed:
                                  () =>
                                      _editar(criterio),
                              child:
                                  const Text(
                                'Editar',
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors
                                        .red,
                                foregroundColor:
                                    Colors
                                        .white,
                              ),
                              onPressed:
                                  () =>
                                      _eliminar(
                                criterio
                                    .id!,
                              ),
                              child:
                                  const Text(
                                'Eliminar',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}