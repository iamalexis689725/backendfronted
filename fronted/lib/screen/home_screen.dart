import 'package:flutter/material.dart';
import '../screen/tenant_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF4F46E5),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.dashboard, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Bienvenido a MI COLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        icon: const Icon(Icons.add, color: Color(0xFF4F46E5)),
        label: const Text(
          'Crear Colegio',
          style: TextStyle(color: Color(0xFF4F46E5)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TenantScreen(),
            ),
          );
        },
      ),
    );
  }
}