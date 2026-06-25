import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/tenant_viewmodel.dart';

class TenantListScreen extends StatefulWidget {
  const TenantListScreen({super.key});

  @override
  State<TenantListScreen> createState() =>
      _TenantListScreenState();
}

class _TenantListScreenState
    extends State<TenantListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        context.read<TenantViewModel>()
            .loadTenants());
  }

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<TenantViewModel>();

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/colegios/create');
        },
        child: const Icon(Icons.add),
      ),

      body: vm.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : vm.error != null
              ? Center(
                  child: Text(vm.error!),
                )

              : vm.tenants.isEmpty
                  ? const Center(
                      child: Text('No hay colegios'),
                    )

                  : ListView.builder(
                      itemCount: vm.tenants.length,

                      itemBuilder: (_, i) {

                        final t = vm.tenants[i];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          elevation: 2,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),

                          child: ListTile(

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),

                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  Colors.grey[200],

                              backgroundImage:
                                  t.logoUrl != null
                                      ? NetworkImage(
                                          t.logoUrl!,
                                        )
                                      : null,

                              child: t.logoUrl == null
                                  ? const Icon(
                                      Icons.school,
                                    )
                                  : null,
                            ),

                            title: Text(
                              t.name ?? '',

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              t.slug ?? '',

                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            // ===================================
                            // MENU
                            // ===================================

                            trailing:
                                PopupMenuButton<String>(

                              onSelected:
                                  (value) async {

                                // =====================
                                // MODULOS
                                // =====================

                                if (value ==
                                    'modules') {

                                  context.go(
                                    '/colegios/${t.id}/modules',
                                  );
                                }

                                // =====================
                                // ELIMINAR
                                // =====================

                                if (value ==
                                    'delete') {

                                  final confirm =
                                      await showDialog<bool>(

                                    context: context,

                                    builder: (_) =>
                                        AlertDialog(

                                      title:
                                          const Text(
                                        '¿Eliminar colegio?',
                                      ),

                                      content: Text(
                                        'Se eliminará "${t.name}" permanentemente.',
                                      ),

                                      actions: [

                                        TextButton(

                                          onPressed:
                                              () =>
                                                  context.pop(
                                                      false),

                                          child:
                                              const Text(
                                            'Cancelar',
                                          ),
                                        ),

                                        ElevatedButton(

                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red,
                                          ),

                                          onPressed:
                                              () =>
                                                  context.pop(
                                                      true),

                                          child:
                                              const Text(
                                            'Eliminar',

                                            style:
                                                TextStyle(
                                              color:
                                                  Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm ==
                                          true &&
                                      mounted) {

                                    final success =
                                        await vm
                                            .deleteTenant(
                                      t.id!,
                                    );

                                    if (!mounted)
                                      return;

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(

                                      SnackBar(
                                        content:
                                            Text(

                                          success
                                              ? 'Colegio eliminado'
                                              : vm.error ??
                                                  'Error al eliminar',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },

                              itemBuilder: (_) => [

                                const PopupMenuItem(
                                  value:
                                      'modules',

                                  child: Row(
                                    children: [

                                      Icon(
                                        Icons
                                            .extension,
                                      ),

                                      SizedBox(
                                        width: 10,
                                      ),

                                      Text(
                                        'Módulos',
                                      ),
                                    ],
                                  ),
                                ),

                                const PopupMenuItem(
                                  value:
                                      'delete',

                                  child: Row(
                                    children: [

                                      Icon(
                                        Icons.delete,
                                        color:
                                            Colors.red,
                                      ),

                                      SizedBox(
                                        width: 10,
                                      ),

                                      Text(
                                        'Eliminar',
                                      ),
                                    ],
                                  ),
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