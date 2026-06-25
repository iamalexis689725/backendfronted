import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/tenant_viewmodel.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String location;

  const MainLayout({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const Color primary = Color(0xFF4F46E5);
  static const Color bg = Color(0xFFF5F7FB);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = context.read<AuthViewModel>();

      if (auth.role == 'director') {
        final vm = context.read<TenantViewModel>();

        if (vm.currentTenant == null && !vm.loading) {
          vm.loadMyTenant();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final tenant = context.watch<TenantViewModel>();
    final role = auth.role ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: bg,

          drawer: isDesktop ? null : _buildDrawer(context, role),

          appBar: _buildTopBar(context, auth, tenant, isDesktop),

          body: Row(
            children: [
              if (isDesktop) _buildSidebar(context, role),
              Expanded(child: widget.child),
            ],
          ),

          bottomNavigationBar:
              isDesktop ? null : _buildBottomNav(context, role),
        );
      },
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================
  PreferredSizeWidget _buildTopBar(
    BuildContext context,
    AuthViewModel auth,
    TenantViewModel tenant,
    bool isDesktop,
  ) {
    final role = auth.role ?? '';

    final title = role == 'director'
        ? (tenant.currentTenant?.name ?? 'Mi Colegio')
        : role == 'super-admin'
            ? 'Panel Admin'
            : 'Mi Panel';

    final subtitle = role == 'director'
        ? 'Panel Director'
        : role == 'super-admin'
            ? 'Super Administrador'
            : role.toUpperCase();

    return AppBar(
      backgroundColor: primary,
      elevation: 0,
      automaticallyImplyLeading: !isDesktop,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showLogoutDialog(context),
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _initials(auth.user?.name ?? '?'),
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ==========================================================
  // SIDEBAR DESKTOP
  // ==========================================================
  Widget _buildSidebar(BuildContext context, String role) {
    final items = _menuItems(role);

    return Container(
      width: 270,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 18),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.dashboard_outlined, color: primary),
                SizedBox(width: 10),
                Text(
                  'Menú Principal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: items.map((e) {
                final active = widget.location.startsWith(e.route);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Material(
                    color: active
                        ? primary.withOpacity(.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: Icon(
                        e.icon,
                        color: active ? primary : Colors.grey[700],
                      ),
                      title: Text(
                        e.label,
                        style: TextStyle(
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? primary : Colors.black87,
                        ),
                      ),
                      onTap: () => context.go(e.route),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DRAWER MOBILE
  // ==========================================================
  Widget _buildDrawer(BuildContext context, String role) {
    final items = _menuItems(role);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Menú',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            Expanded(
              child: ListView(
                children: items.map((e) {
                  return ListTile(
                    leading: Icon(e.icon),
                    title: Text(e.label),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(e.route);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAV MOBILE POR ROL
  // ==========================================================
  Widget _buildBottomNav(BuildContext context, String role) {
    List<_MenuItem> tabs;

    if (role == 'super-admin') {
      tabs = [
        _MenuItem('Inicio', Icons.home_outlined, '/home'),
        _MenuItem('Colegios', Icons.school_outlined, '/colegios'),
        _MenuItem('Más', Icons.menu, '/more'),
      ];
    } else if (role == 'profesor' || role == 'estudiante'|| role == 'padre') {
      tabs = [
        _MenuItem('Inicio', Icons.home_outlined, '/home'),
        _MenuItem('Avisos', Icons.campaign_outlined, '/circulares'),
        _MenuItem('Más', Icons.menu, '/more'),
      ];
    } else {
      tabs = [
        _MenuItem('Inicio', Icons.home_outlined, '/home'),
        _MenuItem('Colegio', Icons.school_outlined, '/colegio'),
        _MenuItem('Avisos', Icons.campaign_outlined, '/circulares'),
        _MenuItem('Más', Icons.menu, '/more'),
      ];
    }

    int selectedIndex = 0;

    for (int i = 0; i < tabs.length; i++) {
      if (widget.location.startsWith(tabs[i].route) &&
          tabs[i].route != '/more') {
        selectedIndex = i;
      }
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      height: 72,
      backgroundColor: Colors.white,
      indicatorColor: primary.withOpacity(.12),
      onDestinationSelected: (value) {
        final route = tabs[value].route;

        if (route == '/more') {
          _scaffoldKey.currentState?.openDrawer();
        } else {
          context.go(route);
        }
      },
      destinations: tabs.map((e) {
        return NavigationDestination(
          icon: Icon(e.icon),
          label: e.label,
        );
      }).toList(),
    );
  }

  // ==========================================================
  // MENU POR ROL
  // ==========================================================
  List<_MenuItem> _menuItems(String role) {
    switch (role) {
      case 'super-admin':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Colegios', Icons.school_outlined, '/colegios'),
          _MenuItem(
              'Crear Colegio', Icons.add_business_outlined, '/colegios/create'),
        ];

      case 'profesor':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
           _MenuItem('Mis Clases', Icons.class_outlined, '/mis-clases'),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
          
        ];
        case 'padre':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Mis Hijos',Icons.school_outlined,'/mis-hijos',),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
        ];

      case 'estudiante':
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
          _MenuItem('Mi Horario', Icons.schedule_outlined, '/mi-horario'),
        ];

      case 'director':
      default:
        return [
          _MenuItem('Inicio', Icons.home_outlined, '/home'),
          _MenuItem('Materias', Icons.menu_book_outlined, '/materias'),
          _MenuItem('Profesores', Icons.person_outline, '/profesores'),
          _MenuItem('Estudiantes', Icons.school_outlined, '/estudiantes'),
          _MenuItem('Padres', Icons.family_restroom, '/padres'),
          _MenuItem('Inscripciones', Icons.assignment_ind_outlined, '/inscripciones'),
          _MenuItem('Cursos', Icons.class_outlined, '/cursos'),
          _MenuItem('Períodos', Icons.calendar_month_outlined, '/periodos'),
          _MenuItem('Colegio', Icons.school_outlined, '/colegio'),
          _MenuItem('Circulares', Icons.campaign_outlined, '/circulares'),
        ];
    }
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================
  Future<void> _showLogoutDialog(BuildContext context) async {
    final auth = context.read<AuthViewModel>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Cerrar sesión'),
          content: const Text('¿Deseas salir de la aplicación?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await auth.logout();

      if (mounted) {
        context.go('/login');
      }
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }

    return '?';
  }
}

// ==========================================================
// MODEL
// ==========================================================
class _MenuItem {
  final String label;
  final IconData icon;
  final String route;

  _MenuItem(this.label, this.icon, this.route);
}