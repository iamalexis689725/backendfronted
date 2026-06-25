import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/padre_anecdotario_viewmodel.dart';

class PadreAnecdotarioScreen
    extends StatefulWidget {
  final int estudianteId;

  const PadreAnecdotarioScreen({
    super.key,
    required this.estudianteId,
  });

  @override
  State<PadreAnecdotarioScreen>
      createState() =>
          _PadreAnecdotarioScreenState();
}

class _PadreAnecdotarioScreenState
    extends State<
        PadreAnecdotarioScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<
              PadreAnecdotarioViewModel>()
          .loadAnecdotarios(
            widget.estudianteId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        context.watch<
            PadreAnecdotarioViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anecdotario',
        ),
      ),
      body: vm.loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : vm.error != null
              ? Center(
                  child: Text(
                    vm.error!,
                  ),
                )
              : vm.anecdotarios.isEmpty
                  ? const Center(
                      child: Text(
                        'No existen registros',
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets
                              .all(16),
                      itemCount:
                          vm.anecdotarios
                              .length,
                      itemBuilder:
                          (context,
                              index) {
                        final item =
                            vm.anecdotarios[
                                index];

                        return Card(
                          elevation: 2,
                          margin:
                              const EdgeInsets
                                  .only(
                            bottom: 12,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets
                                    .all(
                              16,
                            ),
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Text(
                                      item.tipo ??
                                          '',
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.fecha ??
                                          '',
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height:
                                      10,
                                ),

                                Text(
                                  item.titulo ??
                                      '',
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      8,
                                ),

                                Text(
                                  item.descripcion ??
                                      '',
                                ),

                                const Divider(),

                                Text(
                                  'Materia: ${item.materia ?? ''}',
                                ),

                                Text(
                                  'Profesor: ${item.profesor ?? ''}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}