import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/circular_viewmodel.dart';

class CircularCreateScreen extends StatefulWidget {
  const CircularCreateScreen({super.key});

  @override
  State<CircularCreateScreen> createState() => _CircularCreateScreenState();
}

class _CircularCreateScreenState extends State<CircularCreateScreen> {
  static const _purple = Color(0xFF4F46E5);

  final _formKey        = GlobalKey<FormState>();
  final tituloController    = TextEditingController();
  final contenidoController = TextEditingController();
  String _target = 'all';

  static const _targets = [
    ('all',         'Todos'),
    ('padres',      'Padres'),
    ('profesores',  'Profesores'),
    ('estudiantes', 'Estudiantes'),
  ];

  @override
  void dispose() {
    tituloController.dispose();
    contenidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CircularViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        title: const Text('Nueva Circular'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Título ────────────────────────────────────────────────
              const Text('Título',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: tituloController,
                decoration: InputDecoration(
                  hintText: 'Ej: Reunión de padres de familia',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),

              const SizedBox(height: 20),

              // ── Destinatario ──────────────────────────────────────────
              const Text('Destinatario',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _targets.map((t) {
                  final selected = _target == t.$1;
                  return ChoiceChip(
                    label: Text(t.$2),
                    selected: selected,
                    selectedColor: _purple,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    onSelected: (_) => setState(() => _target = t.$1),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ── Contenido ─────────────────────────────────────────────
              const Text('Contenido',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: contenidoController,
                minLines: 6,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: 'Escribe el mensaje de la circular...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                  alignLabelWithHint: true,
                ),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              if (vm.error != null) ...[
  const SizedBox(height: 12),

  Text(
    vm.error!,
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w600,
    ),
  ),
],
              const SizedBox(height: 32),

              // ── Botón ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: vm.creating
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          FocusScope.of(context).unfocus();

                          final success = await vm.createCircular(
                            titulo:    tituloController.text.trim(),
                            contenido: contenidoController.text.trim(),
                            target:    _target,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(success 
                                ? 'Circular enviada correctamente'
                                : (vm.error ?? 'Error al crear')
                          ) ));

                          if (success) context.go('/circulares');
                        },
                  icon: vm.creating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send),
                  label: Text(vm.creating ? 'Enviando...' : 'Enviar circular'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}