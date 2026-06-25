import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/tenant_viewmodel.dart';

class MyTenantScreen extends StatefulWidget {
  const MyTenantScreen({super.key});

  @override
  State<MyTenantScreen> createState() =>
      _MyTenantScreenState();
}

class _MyTenantScreenState
    extends State<MyTenantScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        context.read<TenantViewModel>()
            .loadMyTenant());
  }

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<TenantViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: vm.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : vm.error != null
              ? Center(
                  child: Text(vm.error!),
                )

              : vm.currentTenant == null
                  ? const Center(
                      child: Text(
                        'No hay datos del colegio',
                      ),
                    )

                  : Center(
                      child: Container(

                        constraints:
                            const BoxConstraints(
                          maxWidth: 500,
                        ),

                        margin:
                            const EdgeInsets.all(20),

                        child: Card(

                          elevation: 6,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: Padding(

                            padding:
                                const EdgeInsets.all(
                              24,
                            ),

                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                ClipRRect(

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    16,
                                  ),

                                  child: vm.currentTenant!
                                              .logoUrl !=
                                          null

                                      ? Image.network(

                                          vm.currentTenant!
                                                  .logoUrl! +
                                              '?t=${DateTime.now().millisecondsSinceEpoch}',

                                          width: 120,
                                          height: 120,

                                          fit: BoxFit.cover,
                                        )

                                      : Container(

                                          width: 120,
                                          height: 120,

                                          color:
                                              Colors.grey[
                                                  200],

                                          child:
                                              const Icon(
                                            Icons.school,
                                            size: 50,
                                          ),
                                        ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                Text(

                                  vm.currentTenant!
                                          .name ??
                                      '',

                                  style:
                                      const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(

                                  vm.currentTenant!
                                          .slug ??
                                      '',

                                  style:
                                      const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                SizedBox(

                                  width:
                                      double.infinity,

                                  child:
                                      ElevatedButton.icon(

                                    icon: const Icon(
                                      Icons.edit,
                                    ),

                                    label: const Text(
                                      'Editar colegio',
                                    ),

                                    onPressed: () {

                                      context.go(
                                        '/colegio/editar',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
    );
  }
}