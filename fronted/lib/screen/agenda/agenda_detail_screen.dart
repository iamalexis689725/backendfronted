// agenda_detail_screen.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/agenda.dart';
import '../../viewmodels/agenda_viewmodel.dart';

class AgendaDetailScreen extends StatefulWidget {

  final int agendaId;

  const AgendaDetailScreen({
    super.key,
    required this.agendaId,
  });

  @override
  State<AgendaDetailScreen> createState() =>
      _AgendaDetailScreenState();
}

class _AgendaDetailScreenState
    extends State<AgendaDetailScreen> {

  Agenda? agenda;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    cargar();
  }

  // =========================
  // CARGAR
  // =========================

  Future<void> cargar() async {

    if (!mounted) return;

    setState(() {
      loading = true;
    });

    try {

      final vm =
          context.read<AgendaViewModel>();

      final data =
          await vm.repository.getAgendaDetalle(
        widget.agendaId,
      );

      if (!mounted) return;

      setState(() {

        agenda = data;

        loading = false;
      });

    } catch (_) {

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  // =========================
  // SUBIR ARCHIVOS
  // =========================

  Future<void> subirArchivos() async {

    final result =
        await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    final vm =
        context.read<AgendaViewModel>();

    final ok =
        await vm.subirArchivos(
      agendaId: widget.agendaId,
      archivos: result.files,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Archivos subidos'
              : vm.error ?? 'Error',
        ),
      ),
    );

    if (ok) {

      await cargar();
    }
  }

  // =========================
  // REEMPLAZAR
  // =========================

  Future<void> reemplazarArchivo(
    int archivoId,
  ) async {

    final result =
        await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) return;

    final archivo =
        result.files.first;

    final vm =
        context.read<AgendaViewModel>();

    final ok =
        await vm.reemplazarArchivo(
      archivoId: archivoId,
      archivo: archivo,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Archivo reemplazado'
              : vm.error ?? 'Error',
        ),
      ),
    );

    if (ok) {

      await cargar();
    }
  }

  // =========================
  // ELIMINAR ARCHIVO
  // =========================

  Future<void> eliminarArchivo(
    int archivoId,
  ) async {

    final confirm =
        await showDialog<bool>(

      context: context,

      builder: (dialogContext) {

        return AlertDialog(

          title: const Text(
            'Eliminar archivo',
          ),

          content: const Text(
            '¿Seguro que deseas eliminar el archivo?',
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.of(
                  dialogContext,
                ).pop(false);
              },

              child: const Text(
                'Cancelar',
              ),
            ),

            ElevatedButton(

              style:
                  ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () {

                Navigator.of(
                  dialogContext,
                ).pop(true);
              },

              child: const Text(
                'Eliminar',

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final vm =
        context.read<AgendaViewModel>();

    final ok =
        await vm.eliminarArchivo(
      archivoId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Archivo eliminado'
              : vm.error ?? 'Error',
        ),
      ),
    );

    if (ok) {

      await cargar();
    }
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<AgendaViewModel>();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Archivos',
        ),
      ),

      body:
          loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : agenda == null

                  ? const Center(
                      child: Text(
                        'No se encontró agenda',
                      ),
                    )

                  : Padding(
                      padding:
                          const EdgeInsets.all(16),

                      child: Column(
                        children: [

                          SizedBox(
                            width: double.infinity,

                            child:
                                ElevatedButton.icon(

                              onPressed:
                                  vm.uploading
                                      ? null
                                      : subirArchivos,

                              icon:
                                  vm.uploading

                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,

                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color:
                                                Colors.white,
                                          ),
                                        )

                                      : const Icon(
                                          Icons.upload_file,
                                        ),

                              label: Text(
                                vm.uploading
                                    ? 'Subiendo...'
                                    : 'Subir archivos',
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Expanded(

                            child:
                                agenda!
                                        .archivos
                                        .isEmpty

                                    ? const Center(
                                        child: Text(
                                          'No hay archivos',
                                        ),
                                      )

                                    : ListView.builder(

                                        itemCount:
                                            agenda!
                                                .archivos
                                                .length,

                                        itemBuilder:
                                            (_, i) {

                                          final archivo =
                                              agenda!
                                                      .archivos[
                                                  i];

                                          return Card(

                                            child:
                                                ListTile(

                                              leading:
                                                  const Icon(
                                                Icons
                                                    .insert_drive_file,
                                              ),

                                              title: Text(
                                                archivo
                                                    .nombreOriginal,
                                              ),

                                              trailing:
                                                  Row(

                                                mainAxisSize:
                                                    MainAxisSize
                                                        .min,

                                                children: [

                                                  IconButton(

                                                    onPressed:
                                                        () {

                                                      reemplazarArchivo(
                                                        archivo.id!,
                                                      );
                                                    },

                                                    icon:
                                                        const Icon(
                                                      Icons.edit,
                                                      color:
                                                          Colors.orange,
                                                    ),
                                                  ),

                                                  IconButton(

                                                    onPressed:
                                                        () {

                                                      eliminarArchivo(
                                                        archivo.id!,
                                                      );
                                                    },

                                                    icon:
                                                        const Icon(
                                                      Icons.delete,
                                                      color:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}