import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PadreDashboardScreen extends StatelessWidget {
  final int estudianteId;

  const PadreDashboardScreen({
    super.key,
    required this.estudianteId,
  });
/* 
  static const Color primary = Color(0xFF4F46E5); */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* backgroundColor: const Color(0xFFF5F7FB), */
      appBar: AppBar(
        title: const Text("Mi hijo"),
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final itemHeight = (constraints.maxHeight - 20 - 20 - 16) / 2;
          final itemWidth = (constraints.maxWidth - 20 - 20 - 16) / 2;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: itemWidth / itemHeight,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _MenuCard(
                  icon: Icons.assignment_outlined,
                  title: "Agendas",
                  color: Colors.orange,
                  onTap: () => context.go('/mis-hijos/$estudianteId/agendas'),
                ),
                _MenuCard(
                  icon: Icons.grade_outlined,
                  title: "Boleta",
                  color: Colors.green,
                  onTap: () => context.go('/mis-hijos/$estudianteId/notas'),
                ),
                _MenuCard(
                  icon: Icons.menu_book_outlined,
                  title: "Anecdotario",
                  color: Colors.red,
                  onTap: () => context.go('/mis-hijos/$estudianteId/anecdotarios'),
                ),
                _MenuCard(
                  icon: Icons.fact_check_outlined,
                  title: "Asistencias",
                  color: Colors.blue,
                  onTap: () => context.go('/mis-hijos/$estudianteId/asistencias'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}