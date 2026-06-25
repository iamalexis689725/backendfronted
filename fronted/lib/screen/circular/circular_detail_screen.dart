import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/circular_viewmodel.dart';

class CircularDetailScreen extends StatefulWidget {
  final int id;

  const CircularDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<CircularDetailScreen> createState() => _CircularDetailScreenState();
}

class _CircularDetailScreenState extends State<CircularDetailScreen> {
  static const _purple = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final vm = context.read<CircularViewModel>();
      await vm.loadCircularDetail(widget.id);
      if (!(vm.selected?.leido ?? false)) {
        await vm.marcarLeido(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CircularViewModel>();

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            vm.error!,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final c = vm.selected;

    if (c == null) {
      return const Scaffold(
        body: Center(child: Text('No encontrado')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Circular'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header card ──────────────────────────────
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.campaign_outlined,
                            color: _purple,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            c.titulo ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Por ${c.creadoPor ?? ''}',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        if (c.leido == true) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  'Leído',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Contenido ────────────────────────────────
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contenido',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Text(
                      c.contenido ?? '',
                      style: const TextStyle(fontSize: 15, height: 1.7),
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