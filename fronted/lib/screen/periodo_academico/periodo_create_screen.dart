import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/academic_period_viewmodel.dart';

class PeriodoCreateScreen extends StatefulWidget {
  const PeriodoCreateScreen({super.key});

  @override
  State<PeriodoCreateScreen> createState() => _PeriodoCreateScreenState();
}

class _PeriodoCreateScreenState extends State<PeriodoCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _activar = false;

  static const _purple = Color(0xFF4F46E5);

  Future<void> _pickFecha(bool isInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AcademicPeriodViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Nuevo Periodo Académico'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.calendar_month, size: 60, color: _purple),
                  const SizedBox(height: 10),

                  const Text(
                    'Crear Periodo Académico',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del periodo',
                      hintText: 'Ej: 2026 - I',
                      prefixIcon: const Icon(Icons.label),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Campo requerido' : null,
                  ),

                  const SizedBox(height: 16),

                  _DateTile(
                    label: _fechaInicio == null
                        ? 'Fecha de inicio'
                        : 'Inicio: ${_formatDate(_fechaInicio!)}',
                    icon: Icons.event,
                    onTap: () => _pickFecha(true),
                  ),

                  const SizedBox(height: 12),

                  _DateTile(
                    label: _fechaFin == null
                        ? 'Fecha de fin'
                        : 'Fin: ${_formatDate(_fechaFin!)}',
                    icon: Icons.event_available,
                    onTap: () => _pickFecha(false),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Text('Activar'),
                      const Spacer(),
                      Switch(
                        value: _activar,
                        onChanged: (v) => setState(() => _activar = v),
                      ),
                    ],
                  ),
                  if (vm.error != null) ...[
  const SizedBox(height: 10),

  Text(
    vm.error!,
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w600,
    ),
  ),
],
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: vm.creating
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              if (_fechaInicio == null || _fechaFin == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Selecciona las fechas')),
                                );
                                return;
                              }

                              if (_fechaFin!.isBefore(_fechaInicio!)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Fecha fin inválida')),
                                );
                                return;
                              }

                              FocusScope.of(context).unfocus();

                              final ok = await vm.createPeriodo(
                                nombre: nombreController.text.trim(),
                                fechaInicio: _formatDate(_fechaInicio!),
                                fechaFin: _formatDate(_fechaFin!),
                                activo: _activar,
                              );

                              if (!mounted) return;

                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Periodo creado correctamente')),
                                );

                                context.go('/periodos');
                              }
                            },
                      child: vm.creating
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Crear Periodo'),
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

class _DateTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(label),
            const Spacer(),
            const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }
}