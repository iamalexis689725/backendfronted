import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/module_viewmodel.dart';

class ModuleScreen extends StatefulWidget {

  final int tenantId;

  const ModuleScreen({
    super.key,
    required this.tenantId,
  });

  @override
  State<ModuleScreen> createState() =>
      _ModuleScreenState();
}

class _ModuleScreenState
    extends State<ModuleScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      context
          .read<ModuleViewModel>()
          .loadModules(widget.tenantId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<ModuleViewModel>();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Control de módulos',
        ),
      ),

      body: vm.loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : vm.error != null
              ? Center(
                  child: Text(vm.error!),
                )

              : ListView.builder(

                  padding:
                      const EdgeInsets.all(16),

                  itemCount: vm.modules.length,

                  itemBuilder: (_, i) {

                    final module =
                        vm.modules[i];

                    return Card(

                      margin:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),

                      child: ListTile(

                        title: Text(
                          module.nombre,
                        ),

                        subtitle: Text(
                          module.codigo,
                        ),

                        trailing: Switch(

                          value: module.activo,

                          onChanged: (value) async {

                            await vm.toggleModule(
                              tenantId:
                                  widget.tenantId,

                              moduleId:
                                  module.id,

                              value: value,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}