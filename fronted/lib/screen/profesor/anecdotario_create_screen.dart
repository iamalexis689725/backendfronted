import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/estudiante_clase.dart';
import '../../viewmodels/anecdotario_viewmodel.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/estudiantes_clase_viewmodel.dart';
import '../../core/widgest/auth_card.dart';

class AnecdotarioCreateScreen extends StatefulWidget {
  final int periodoId;
  final int cursoId;
  final int paraleloId;
  final int asignacionId;

  const AnecdotarioCreateScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.asignacionId,
  });

  @override
  State<AnecdotarioCreateScreen> createState() =>
      _AnecdotarioCreateScreenState();
}

class _AnecdotarioCreateScreenState extends State<AnecdotarioCreateScreen> {
  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  EstudianteClase? estudiante;
  String tipo = 'conducta';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EstudiantesClaseViewModel>().load(
            periodoId: widget.periodoId,
            cursoId: widget.cursoId,
            paraleloId: widget.paraleloId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final estudiantesVM = context.watch<EstudiantesClaseViewModel>();
    final vm = context.watch<AnecdotarioViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Registrar Anecdotario')),
      body: AuthCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 8),
            const Text(
              'Nuevo Anecdotario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text('Estudiante', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<EstudianteClase>(
              value: estudiante,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              hint: const Text('Seleccione estudiante'),
              items: estudiantesVM.estudiantes.map((e) {
                return DropdownMenuItem(value: e, child: Text(e.nombre ?? ''));
              }).toList(),
              onChanged: (e) => setState(() => estudiante = e),
            ),
            const SizedBox(height: 16),

            const Text('Tipo', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: tipo,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              items: const [
                DropdownMenuItem(value: 'conducta',    child: Text('Conducta')),
                DropdownMenuItem(value: 'merito',      child: Text('Mérito')),
                DropdownMenuItem(value: 'observacion', child: Text('Observación')),
              ],
              onChanged: (v) => setState(() => tipo = v!),
            ),
            const SizedBox(height: 16),

            const Text('Título', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: tituloCtrl,
              decoration: InputDecoration(
                hintText: 'Ej: Comportamiento en clase',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: descripcionCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe el evento...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: vm.creating
                    ? null
                    : () async {
                        if (estudiante == null) return;

                        final ok = await vm.createAnecdotario(
                          estudianteId: estudiante!.id!,
                          asignacionDocenteId: widget.asignacionId,
                          academicPeriodId: widget.periodoId,
                          tipo: tipo,
                          titulo: tituloCtrl.text,
                          descripcion: descripcionCtrl.text,
                          fecha: DateTime.now().toString().split(' ').first,
                        );

                        if (ok && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Anecdotario registrado')),
                          );
                          context.go(
                            '/mis-clases/${widget.periodoId}/${widget.cursoId}/${widget.paraleloId}/${widget.asignacionId}/anecdotarios',
                          );
                        }
                      },
                icon: const Icon(Icons.save),
                label: vm.creating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Guardar Anecdotario'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}