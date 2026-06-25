import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/padre_agenda.dart';
import '../../viewmodels/padre_agenda_viewmodel.dart';

class PadreAgendaScreen extends StatefulWidget {
  final int estudianteId;

  const PadreAgendaScreen({
    super.key,
    required this.estudianteId,
  });

  @override
  State<PadreAgendaScreen> createState() => _PadreAgendaScreenState();
}

class _PadreAgendaScreenState extends State<PadreAgendaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PadreAgendaViewModel>().loadAgendasHijo(widget.estudianteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PadreAgendaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Agendas')),
      body: Builder(
        builder: (_) {
          if (vm.loading) return const Center(child: CircularProgressIndicator());
          if (vm.error != null) return Center(child: Text(vm.error!));
          if (vm.agendas.isEmpty) return const Center(child: Text('Sin agendas'));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.agendas.length,
            itemBuilder: (_, index) => _AgendaCard(agenda: vm.agendas[index]),
          );
        },
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final PadreAgenda agenda;

  const _AgendaCard({required this.agenda});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y tipo
            Row(
              children: [
                Expanded(
                  child: Text(
                    agenda.titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Chip(
                  label: Text(agenda.tipo),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Materia
            Text(
              'Materia: ${agenda.materia}',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            // Fecha
            if (agenda.fechaEntrega != null) ...[
              const SizedBox(height: 2),
              Text(
                'Entrega: ${agenda.fechaEntrega}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                    ),
              ),
            ],

            // Descripción
            if (agenda.descripcion.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(agenda.descripcion),
            ],

            // Archivos
            if (agenda.archivos.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                'Archivos adjuntos:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              ...agenda.archivos.map(
                (archivo) => InkWell(
                  onTap: () async {
                    final uri = Uri.parse(archivo.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file, size: 16, color: Colors.blue),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            archivo.nombreOriginal,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}