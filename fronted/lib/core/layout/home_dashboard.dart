import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/tenant_viewmodel.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  static const _purple = Color(0xFF4F46E5);
  static const _bgPage = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final tenantVM = Provider.of<TenantViewModel>(context);

    final role = auth.role;
    final name = auth.user?.name ?? '';

    final schoolName = role == 'director'
        ? (tenantVM.currentTenant?.name ?? '')
        : 'Admin Panel';

    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200, 
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ───────────────── HERO ─────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildHeroLogo(role, tenantVM, name),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hola, ${name.split(' ').first}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    role == 'super-admin'
                                        ? 'Super Administrador'
                                        : 'Panel Director',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 13,
                                    ),
                                  ),

                                  if (role == 'director' &&
                                      schoolName.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      schoolName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            Colors.white.withOpacity(0.95),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Container(
                          height: 0.5,
                          color: Colors.white.withOpacity(0.2),
                        ),

                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _Chip(
                              Icons.check_circle_outline,
                              'Sistema activo',
                            ),
                            _Chip(
                              Icons.wifi_rounded,
                              'En línea',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ───────────────── SUPER ADMIN ─────────────────
                  if (role == 'super-admin') ...[
                    const _SectionLabel('GESTIÓN DE COLEGIOS'),

                    const SizedBox(height: 14),

                    _RowCard(
                      icon: Icons.school_outlined,
                      label: 'Colegios registrados',
                      description:
                          'Ver, editar y eliminar colegios',
                      bgColor: const Color(0xFFEDE9FE),
                      iconColor: const Color(0xFF7C3AED),
                      onTap: () => context.go('/colegios'),
                    ),

                    const SizedBox(height: 12),

                    _RowCard(
                      icon: Icons.add_business_outlined,
                      label: 'Crear nuevo colegio',
                      description:
                          'Registrar un colegio con su director',
                      bgColor: const Color(0xFFD1FAE5),
                      iconColor: const Color(0xFF059669),
                      onTap: () => context.go('/colegios/create'),
                    ),
                  ],

                  // ───────────────── DIRECTOR ─────────────────
                  if (role == 'director') ...[
                    const _SectionLabel('GESTIÓN'),

                    const SizedBox(height: 14),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        int columns = 2;

                        if (constraints.maxWidth > 1000) {
                          columns = 4;
                        } else if (constraints.maxWidth > 700) {
                          columns = 3;
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,                            
                           childAspectRatio:
                      MediaQuery.of(context).size.width < 600
                          ? 1.0
                          : 1.55,
                            
                          ),
                          itemBuilder: (context, index) {
                            final items = [
                              {
                                'icon': Icons.menu_book_outlined,
                                'label': 'Materias',
                                'bg': const Color(0xFFEDE9FE),
                                'iconColor': const Color(0xFF7C3AED),
                                'route': '/materias',
                              },
                              {
                                'icon': Icons.person_outline,
                                'label': 'Profesores',
                                'bg': const Color(0xFFDBEAFE),
                                'iconColor': const Color(0xFF2563EB),
                                'route': '/profesores',
                              },
                              {
                                'icon': Icons.class_outlined,
                                'label': 'Cursos',
                                'bg': const Color(0xFFD1FAE5),
                                'iconColor': const Color(0xFF059669),
                                'route': '/cursos',
                              },
                              {
                                'icon':
                                    Icons.account_tree_outlined,
                                'label': 'Paralelos',
                                'bg': const Color(0xFFFEE2E2),
                                'iconColor':
                                    const Color(0xFFDC2626),
                                'route': '/cursos',
                              },
                            ];

                            final item = items[index];

                            return _GridCard(
                              icon: item['icon'] as IconData,
                              label: item['label'] as String,
                              bgColor: item['bg'] as Color,
                              iconColor:
                                  item['iconColor'] as Color,
                              onTap: () => context.go(
                                item['route'] as String,
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    _RowCard(
                      icon: Icons.domain_outlined,
                      label: 'Mi Colegio',
                      description:
                          'Logo, nombre y configuración',
                      bgColor: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFD97706),
                      onTap: () => context.go('/colegio'),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroLogo(
    String? role,
    TenantViewModel tenantVM,
    String name,
  ) {
    final logoUrl =
        role == 'director' ? tenantVM.currentTenant?.logoUrl : null;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          logoUrl,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarFallback(name),
        ),
      );
    }

    return _avatarFallback(name);
  }

  Widget _avatarFallback(String name) => Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          _initials(name),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  String _initials(String name) {
    final p = name.trim().split(' ');

    if (p.length >= 2) {
      return '${p[0][0]}${p[1][0]}'.toUpperCase();
    }

    return p[0].isNotEmpty
        ? p[0][0].toUpperCase()
        : '?';
  }
}

class _GridCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _GridCard({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF4F46E5)
                            .withOpacity(0.85),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: const Color(0xFF4F46E5)
                          .withOpacity(0.85),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────── ROW CARD ─────────────────

class _RowCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _RowCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF9CA3AF),
        letterSpacing: 1.1,
      ),
    );
  }
}