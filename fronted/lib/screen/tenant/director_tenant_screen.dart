import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/tenant_viewmodel.dart';

import '../../core/widgest/app/app_card.dart';
import '../../core/widgest/app/app_input.dart';

class DirectorTenantScreen extends StatefulWidget {
  const DirectorTenantScreen({super.key});

  @override
  State<DirectorTenantScreen> createState() =>
      _DirectorTenantScreenState();
}

class _DirectorTenantScreenState
    extends State<DirectorTenantScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController =
      TextEditingController();

  final slugController =
      TextEditingController();

  XFile? _selectedFile;

  Uint8List? _previewBytes;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {

      final vm =
          context.read<TenantViewModel>();

      await vm.loadMyTenant();

      if (!mounted) return;

      if (vm.currentTenant != null) {

        nameController.text =
            vm.currentTenant!.name ?? '';

        slugController.text =
            vm.currentTenant!.slug ?? '';
      }
    });
  }

  @override
  void dispose() {

    nameController.dispose();

    slugController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {

    final picker = ImagePicker();

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {

      final bytes =
          await picked.readAsBytes();

      setState(() {

        _selectedFile = picked;

        _previewBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<TenantViewModel>();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text('Mi Colegio'),
      ),

      body: vm.loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(20),

              child: Column(
                children: [

                  if (vm.error != null)

                    Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(
                        12,
                      ),

                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      decoration: BoxDecoration(

                        color:
                            Colors.red.shade50,

                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),

                      child: Text(

                        vm.error!,

                        style:
                            const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),

                  // =========================
                  // LOGO
                  // =========================

                  AppCard(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        const Text(

                          'Logo del colegio',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Center(

                          child: GestureDetector(

                            onTap: _pickImage,

                            child: Container(

                              width: 120,
                              height: 120,

                              decoration:
                                  BoxDecoration(

                                color:
                                    Colors.grey[200],

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),

                                border: Border.all(
                                  color: Colors
                                      .blue
                                      .shade200,
                                ),
                              ),

                              child:
                                  _previewBytes != null

                                      ? ClipRRect(

                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            12,
                                          ),

                                          child:
                                              Image.memory(

                                            _previewBytes!,

                                            fit: BoxFit.cover,
                                          ),
                                        )

                                      : vm.currentTenant
                                                  ?.logoUrl !=
                                              null

                                          ? ClipRRect(

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                12,
                                              ),

                                              child:
                                                  Image.network(

                                                vm.currentTenant!
                                                        .logoUrl! +
                                                    '?t=${DateTime.now().millisecondsSinceEpoch}',

                                                fit: BoxFit.cover,
                                              ),
                                            )

                                          : const Column(

                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,

                                              children: [

                                                Icon(
                                                  Icons
                                                      .add_photo_alternate,
                                                  size: 40,
                                                  color:
                                                      Colors.blue,
                                                ),

                                                SizedBox(
                                                  height: 8,
                                                ),

                                                Text(

                                                  'Seleccionar',

                                                  style:
                                                      TextStyle(
                                                    color:
                                                        Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        SizedBox(

                          width: double.infinity,

                          child:
                              ElevatedButton.icon(

                            icon: vm.uploading

                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Colors.white,
                                    ),
                                  )

                                : const Icon(
                                    Icons.upload,
                                  ),

                            label: const Text(
                              'Subir logo',
                            ),

                            onPressed:
                                vm.uploading ||
                                        _selectedFile ==
                                            null
                                    ? null
                                    : () async {

                                        final ok =
                                            await vm
                                                .uploadLogo(
                                          _selectedFile!,
                                        );

                                        if (!mounted) {
                                          return;
                                        }

                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(

                                          SnackBar(

                                            content: Text(

                                              ok
                                                  ? 'Logo actualizado'
                                                  : vm.error ??
                                                      'Error al subir logo',
                                            ),
                                          ),
                                        );

                                        if (ok) {

                                          context.go(
                                            '/colegio',
                                          );
                                        }
                                      },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =========================
                  // DATOS
                  // =========================

                  AppCard(

                    child: Form(

                      key: _formKey,

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          const Text(

                            'Datos del colegio',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          AppInput(

                            controller:
                                nameController,

                            label:
                                'Nombre del colegio',

                            icon: Icons.school,

                            validator: (v) =>
                                v == null ||
                                        v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          AppInput(

                            controller:
                                slugController,

                            label:
                                'Slug',

                            icon: Icons.link,

                            validator: (v) =>
                                v == null ||
                                        v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(

                            width: double.infinity,

                            child:
                                ElevatedButton.icon(

                              icon: vm.updating

                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color:
                                            Colors.white,
                                      ),
                                    )

                                  : const Icon(
                                      Icons.save,
                                    ),

                              label: const Text(
                                'Guardar cambios',
                              ),

                              onPressed:
                                  vm.updating
                                      ? null
                                      : () async {

                                          if (!_formKey
                                              .currentState!
                                              .validate()) {
                                            return;
                                          }

                                          final ok =
                                              await vm
                                                  .updateTenant(

                                            name:
                                                nameController
                                                    .text
                                                    .trim(),

                                            slug:
                                                slugController
                                                    .text
                                                    .trim(),
                                          );

                                          if (!mounted) {
                                            return;
                                          }

                                          ScaffoldMessenger
                                                  .of(
                                                      context)
                                              .showSnackBar(

                                            SnackBar(

                                              content: Text(

                                                ok
                                                    ? 'Colegio actualizado'
                                                    : vm.error ??
                                                        'Error al actualizar',
                                              ),
                                            ),
                                          );

                                          if (ok) {

                                            context.go(
                                              '/colegio',
                                            );
                                          }
                                        },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}