import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AuthCard(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, size: 60, color: Colors.blue),

                const SizedBox(height: 10),

                const Text(
                  'MI COLE',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                AuthInput(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Campo requerido';
                    }

                    if (!v.contains('@')) {
                      return 'Correo inválido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                AuthInput(
                  controller: passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Campo requerido';
                    }

                    return null;
                  },
                ),

                if (auth.loginError != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    auth.loginError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        auth.loading
                            ? null
                            : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final success = await auth.login(
                                emailController.text.trim(),
                                passwordController.text,
                              );

                              if (success && mounted) {
                                context.go('/home');
                              }
                            },
                    child:
                        auth.loading
                            ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text('Iniciar sesión'),
                  ),
                ),

                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
