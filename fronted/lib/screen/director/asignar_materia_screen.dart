import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/subject.dart';
import '../../viewmodels/profesor_viewmodel.dart';
import '../../viewmodels/subject_repository.dart';
import '../../core/widgest/auth_card.dart';

class AsignarMateriaScreen extends StatefulWidget {
  final int profesorId;

  const AsignarMateriaScreen({
    super.key,
    required this.profesorId,
  });

  @override
  State<AsignarMateriaScreen> createState() => _AsignarMateriaScreenState();
}

class _AsignarMateriaScreenState extends State<AsignarMateriaScreen> {
  Subject? selectedSubject;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SubjectViewModel>().loadSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectVM = context.watch<SubjectViewModel>();
    final profesorVM = context.watch<ProfesorViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Asignar materia'),
      ),
      body: subjectVM.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selecciona una materia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<Subject>(
                    value: selectedSubject,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Elegir materia'),
                    items: subjectVM.subjects
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.name ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedSubject = v),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),

                      label: profesorVM.assigning
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Asignar'),

                      onPressed: profesorVM.assigning
                          ? null
                          : () async {
                              if (selectedSubject == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Selecciona una materia'),
                                  ),
                                );
                                return;
                              }

                              final success =
                                  await profesorVM.asignarMateria(
                                profesorId: widget.profesorId,
                                subjectId: selectedSubject!.id!,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Materia asignada'
                                        : 'Error al asignar',
                                  ),
                                ),
                              );

                              if (success) {
                                selectedSubject = null;
                                context.go('/profesores');
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}