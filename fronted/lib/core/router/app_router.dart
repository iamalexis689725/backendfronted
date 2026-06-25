import 'package:go_router/go_router.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/profesor.dart';
import '../../models/curso.dart';
// Auth
import '../../screen/login/login_screen.dart';
import '../../screen/login/register_screen.dart';
// Director
import '../../screen/subject/subject_list_screen.dart';
import '../../screen/subject/subject_screen.dart';
import '../../screen/director/profesor_list_screen.dart';
import '../../screen/director/profesor_create_screen.dart';
import '../../screen/director/asignar_materia_screen.dart';
import '../../screen/director/asignar_horario_screen.dart';
import '../../screen/curso/curso_list_screen.dart';
import '../../screen/curso/curso_create_screen.dart';
import '../../screen/paralelo/paralelo_list_screen.dart';
import '../../screen/paralelo/paralelo_create_screen.dart';
import '../../screen/periodo_academico/periodo_list_screen.dart';
import '../../screen/periodo_academico/periodo_create_screen.dart';
import '../../screen/tenant/my_tenant_screen.dart';
import '../../screen/tenant/director_tenant_screen.dart';
import '../../screen/estudiante/estudiante_list_screen.dart';
import '../../screen/estudiante/estudiante_create_screen.dart';
import '../../screen/padre_familia/padre_list_screen.dart';
import '../../screen/padre_familia/padre_create_screen.dart';
import '../../screen/director/horario_profesor_screen.dart';
import '../../screen/horario/horario_curso_screen.dart';
import '../../screen/circular/circular_create_screen.dart';
import '../../screen/circular/circular_list_screen.dart';
import '../../screen/circular/circular_detail_screen.dart';
import '../../screen/inscripcion/inscripcion_create_screen.dart';
import '../../screen/inscripcion/inscripcion_list_screen.dart';
import '../../screen/profesor/mis_clases_screen.dart';
import '../../screen/profesor/clase_dashboard_screen.dart';
import '../../screen/profesor/anecdotario_list_screen.dart';
import '../../screen/profesor/anecdotario_create_screen.dart';
import '../../screen/profesor/asistencia_create_screen.dart';
import '../../screen/agenda/agenda_list_screen.dart';
import '../../screen/agenda/agenda_create_screen.dart';
import '../../screen/agenda/agenda_detail_screen.dart';
import '../../screen/modulos/module_screen.dart';
import '../../screen/estudiante/estudiante_edit_screen.dart';
import '../../screen/criterio/CriterioScreen.dart';
import '../../screen/periodoEvaluacion/PeriodoEvaluacionCreateScreen.dart';
import '../../screen/periodoEvaluacion/PeriodoEvaluacionListScreen.dart';
import '../../screen/libro_calificaciones/libro_calificaciones_screen.dart';
import '../../screen/padre_familia/padre_edit_screen.dart';
import '../../screen/director/profesor_edit_screen.dart';
import '../../screen/subject/subject_edit_screen.dart';
import '../../screen/padre_familia/padre_asignar_estudiante_screen.dart';
import '../../screen/padre_familia/mis_hijos_screen.dart';
import '../../screen/padre_familia/padre_dashboard_screen.dart';
import '../../screen/padre_familia/padre_agenda_screen.dart';
import '../../screen/padre_familia/padre_asistencia_screen.dart';
import '../../screen/padre_familia/padre_anecdotario_screen.dart';
import '../../screen/padre_familia/padre_nota_screen.dart';
// Super Admin
import '../../screen/tenant/tenant_list_screen.dart';
import '../../screen/tenant_screen.dart';

// Layout
import '../layout/main_layout.dart';
import '../layout/home_dashboard.dart';
import '../../screen/estudiante/estudiante_horario_screen.dart';
late GoRouter _routerInstance;

/// Redirige al login sin contexto (usado en el interceptor 401 de Dio).
void redirectToLogin() => _routerInstance.go('/login');

GoRouter createRouter(AuthViewModel authViewModel) {
  _routerInstance = GoRouter(
    initialLocation: authViewModel.isLoggedIn ? '/home' : '/login',

    // Se re-evalúa el redirect cada vez que AuthViewModel notifica cambios.
    refreshListenable: authViewModel,

    redirect: (context, state) {
      final loggedIn = authViewModel.isLoggedIn;
      final isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !isAuthPage) return '/login';
      if (loggedIn && isAuthPage) return '/home';
      return null;
    },

    routes: [
      //Autenticación
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

      // ── Shell principal (AppBar + BottomNav) ─────────────────────────
      ShellRoute(
        builder:
            (context, state, child) => MainLayout(
              child: child,
              //location: state.matchedLocation,
              location: state.matchedLocation,
            ),
        routes: [
          // ── Home
          GoRoute(path: '/home', builder: (_, __) => const HomeDashboard()),

          // DIRECTOR: Materias
          GoRoute(
            path: '/materias',
            builder: (_, __) => const SubjectListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const SubjectScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return SubjectEditScreen(id: id);
                },
              ),
            ],
          ),

          // ── DIRECTOR: Profesores ──────────────────────────────────────
          GoRoute(
            path: '/profesores',
            builder: (_, __) => const ProfesorListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const ProfesorCreateScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return ProfesorEditScreen(id: id);
                },
              ),

              GoRoute(
                // extra: Profesor
                path: ':id/materia',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AsignarMateriaScreen(profesorId: id);
                },
              ),
              GoRoute(
                // extra: Profesor
                path: ':id/horario',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AsignarHorarioScreen(profesorId: id);
                },
              ),
              GoRoute(
                path: ':id/ver-horario',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return HorarioProfesorScreen(profesorId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/estudiantes',
            builder: (_, __) => const EstudianteListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const EstudianteCreateScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return EstudianteEditScreen(id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/padres',
            builder: (_, __) => const PadreListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const PadreCreateScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return PadreEditScreen(id: id);
                },
              ),
              GoRoute(
                path: ':id/estudiantes',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return PadreAsignarEstudianteScreen(padreId: id);
                },
              ),
            ],
          ),

          /* GoRoute(
  path: '/padre/hijo/:estudianteId',
  builder: (_, state) {
    final estudianteId = int.parse(
      state.pathParameters['estudianteId']!,
    );

    return PadreDashboardScreen(
      estudianteId: estudianteId,
    );
  },
), */
          /* GoRoute(
  path: '/padre/:estudianteId/agendas',
  builder: (_, state) {

    final estudianteId = int.parse(
      state.pathParameters['estudianteId']!,
    );

    return PadreAgendaScreen(
      estudianteId: estudianteId,
    );
  },
),
GoRoute(
  path: '/padre/:estudianteId/asistencias',
  builder: (_, state) {

    final estudianteId = int.parse(
      state.pathParameters['estudianteId']!,
    );

    return PadreAsistenciaScreen(
      estudianteId: estudianteId,
    );
  },
),
GoRoute(
  path:
      '/padre/:estudianteId/anecdotarios',
  builder: (_, state) {
    return PadreAnecdotarioScreen(
      estudianteId: int.parse(
        state.pathParameters[
            'estudianteId']!,
      ),
    );
  },
),
GoRoute(
  path: '/padre/:estudianteId/notas',
  builder: (_, state) {
    return PadreNotaScreen(
      estudianteId: int.parse(
        state.pathParameters['estudianteId']!,
      ),
    );
  },
),
 */
          /*   GoRoute(
  path: '/mis-hijos',
  builder: (_, __) => const MisHijosScreen(),
), */
          /* GoRoute(  
  path: '/padre/hijo/:estudianteId',
  builder: (_, state) => PadreDashboardScreen(
    estudianteId: int.parse(state.pathParameters['estudianteId']!),
  ),
  routes: [
    GoRoute(
      path: 'agendas',
      builder: (_, state) => PadreAgendaScreen(
        estudianteId: int.parse(state.pathParameters['estudianteId']!),
      ),
    ),
    GoRoute(
      path: 'notas',
      builder: (_, state) => PadreNotaScreen(
        estudianteId: int.parse(state.pathParameters['estudianteId']!),
      ),
    ),
    GoRoute(
      path: 'asistencias',
      builder: (_, state) => PadreAsistenciaScreen(
        estudianteId: int.parse(state.pathParameters['estudianteId']!),
      ),
    ),
    GoRoute(
      path: 'anecdotarios',
      builder: (_, state) => PadreAnecdotarioScreen(
        estudianteId: int.parse(state.pathParameters['estudianteId']!),
      ),
    ),
  ],
), */
          // ── PADRE: Mis hijos
          GoRoute(
            path: '/mis-hijos',
            builder: (_, __) => const MisHijosScreen(),
            routes: [
              GoRoute(
                path: ':estudianteId', 
                builder:
                    (_, state) => PadreDashboardScreen(
                      estudianteId: int.parse(
                        state.pathParameters['estudianteId']!,
                      ),
                    ),
                routes: [
                  GoRoute(
                    path: 'agendas', // /mis-hijos/:estudianteId/agendas
                    builder:
                        (_, state) => PadreAgendaScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'notas',
                    builder:
                        (_, state) => PadreNotaScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'asistencias',
                    builder:
                        (_, state) => PadreAsistenciaScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'anecdotarios',
                    builder:
                        (_, state) => PadreAnecdotarioScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
          // ── DIRECTOR: Cursos ──────────────────────────────────────────
          GoRoute(
            path: '/cursos',
            builder: (_, __) => const CursoListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const CursoCreateScreen(),
              ),

              GoRoute(
                path: ':cursoId/paralelos',
                builder: (_, state) {
                  final cursoId = int.parse(state.pathParameters['cursoId']!);
                  return ParaleloListScreen(cursoId: cursoId);
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (_, state) {
                      final cursoId = int.parse(
                        state.pathParameters['cursoId']!,
                      );
                      return ParaleloCreateScreen(cursoId: cursoId);
                    },
                  ),
                  GoRoute(
                    path: ':paraleloId/horario',
                    builder: (_, state) {
                      final cursoId = int.parse(
                        state.pathParameters['cursoId']!,
                      );
                      final paraleloId = int.parse(
                        state.pathParameters['paraleloId']!,
                      );
                      return HorarioCursoScreen(
                        cursoId: cursoId,
                        paraleloId: paraleloId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── DIRECTOR: Periodos académicos ─────────────────────────────
          GoRoute(
            path: '/periodos',
            builder: (_, __) => const PeriodoListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const PeriodoCreateScreen(),
              ),
              GoRoute(
                path: ':periodoId/periodos-evaluacion',
                builder: (_, state) {
                  final periodoId = int.parse(
                    state.pathParameters['periodoId']!,
                  );

                  return PeriodoEvaluacionListScreen(periodoId: periodoId);
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (_, state) {
                      final periodoId = int.parse(
                        state.pathParameters['periodoId']!,
                      );

                      return PeriodoEvaluacionCreateScreen(
                        periodoId: periodoId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── DIRECTOR: Mi colegio 
          GoRoute(
            path: '/colegio',
            builder: (_, __) => const MyTenantScreen(),
            routes: [
              GoRoute(
                path: 'editar',
                builder: (_, __) => const DirectorTenantScreen(),
              ),
            ],
          ),

          // ── SUPER ADMIN: Colegios
          GoRoute(
            path: '/colegios',
            builder: (_, __) => const TenantListScreen(),
            routes: [
              GoRoute(path: 'create', builder: (_, __) => const TenantScreen()),
              GoRoute(
                path: ':tenantId/modules',

                builder: (_, state) {
                  return ModuleScreen(
                    tenantId: int.parse(state.pathParameters['tenantId']!),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/circulares',
            builder: (_, __) => const CircularListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const CircularCreateScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return CircularDetailScreen(id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/inscripciones',
            builder: (_, __) => const InscripcionListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const InscripcionCreateScreen(),
              ),
            ],
          ),
        
  GoRoute(
  path: '/mis-clases',
  builder: (_, __) => const MisClasesScreen(),
  routes: [  
    GoRoute(
      path: ':periodoId/:cursoId/:paraleloId/:asignacionId',
      builder: (_, state) => ClaseDashboardScreen(
        periodoId:    int.parse(state.pathParameters['periodoId']!),
        cursoId:      int.parse(state.pathParameters['cursoId']!),
        paraleloId:   int.parse(state.pathParameters['paraleloId']!),
        asignacionId: int.parse(state.pathParameters['asignacionId']!),
        curso:    state.uri.queryParameters['curso'] ?? '',
        paralelo: state.uri.queryParameters['paralelo'] ?? '',
        materia:  state.uri.queryParameters['materia'] ?? '',
      ),
      routes: [
        GoRoute(
          path: 'anecdotarios',
          builder: (_, state) => AnecdotarioListScreen(
            periodoId:    int.parse(state.pathParameters['periodoId']!),
            asignacionId: int.parse(state.pathParameters['asignacionId']!),
          ),
          routes: [
            GoRoute(
              path: 'create',
              builder: (_, state) => AnecdotarioCreateScreen(
                periodoId:    int.parse(state.pathParameters['periodoId']!),
                cursoId:      int.parse(state.pathParameters['cursoId']!),
                paraleloId:   int.parse(state.pathParameters['paraleloId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'asistencia',
          builder: (_, state) => AsistenciaCreateScreen(
            periodoId:    int.parse(state.pathParameters['periodoId']!),
            cursoId:      int.parse(state.pathParameters['cursoId']!),
            paraleloId:   int.parse(state.pathParameters['paraleloId']!),
            asignacionId: int.parse(state.pathParameters['asignacionId']!),
          ),
        ),
        GoRoute(
          path: 'agendas',
          builder: (_, state) => AgendaListScreen(
            periodoId:    int.parse(state.pathParameters['periodoId']!),
            cursoId:      int.parse(state.pathParameters['cursoId']!),
            paraleloId:   int.parse(state.pathParameters['paraleloId']!),
            asignacionId: int.parse(state.pathParameters['asignacionId']!),
          ),
          routes: [
            GoRoute(
              path: 'create',
              builder: (_, state) => AgendaCreateScreen(
                periodoId:    int.parse(state.pathParameters['periodoId']!),
                cursoId:      int.parse(state.pathParameters['cursoId']!),
                paraleloId:   int.parse(state.pathParameters['paraleloId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              ),
            ),
            GoRoute(
              path: ':agendaId',
              builder: (_, state) => AgendaDetailScreen(
                agendaId: int.parse(state.pathParameters['agendaId']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'criterios',
          builder: (_, state) => CriterioScreen(
            periodoId:    int.parse(state.pathParameters['periodoId']!),
            asignacionId: int.parse(state.pathParameters['asignacionId']!),
          ),
        ),
        GoRoute(
          path: 'libro-calificaciones',
          builder: (_, state) => LibroCalificacionesScreen(
            asignacionId: int.parse(state.pathParameters['asignacionId']!),
          ),
        ),
      ],
    ),
  ],
),

GoRoute(
  path: '/mi-horario',
  builder: (_, __) => const EstudianteHorarioScreen(),
),
        /*   GoRoute(
            path: '/mis-clases',
            builder: (_, __) => const MisClasesScreen(),
          ),

          GoRoute(
            path: '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId',
            builder: (_, state) {
              final periodoId = int.parse(state.pathParameters['periodoId']!);

              final cursoId = int.parse(state.pathParameters['cursoId']!);

              final paraleloId = int.parse(state.pathParameters['paraleloId']!);

              final asignacionId = int.parse(
                state.pathParameters['asignacionId']!,
              );

              return ClaseDashboardScreen(
                periodoId: periodoId,
                cursoId: cursoId,
                paraleloId: paraleloId,
                asignacionId: asignacionId,
                curso: state.uri.queryParameters['curso'] ?? '',
                paralelo: state.uri.queryParameters['paralelo'] ?? '',
                materia: state.uri.queryParameters['materia'] ?? '',
              );
            },
          ),
          GoRoute(
            path:
                '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId/anecdotarios',
            builder: (_, state) {
              return AnecdotarioListScreen(
                periodoId: int.parse(state.pathParameters['periodoId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              );
            },
          ),
          GoRoute(
            path:
                '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId/anecdotarios/create',
            builder: (_, state) {
              return AnecdotarioCreateScreen(
                periodoId: int.parse(state.pathParameters['periodoId']!),
                cursoId: int.parse(state.pathParameters['cursoId']!),
                paraleloId: int.parse(state.pathParameters['paraleloId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              );
            },
          ),
          GoRoute(
            path:
                '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId/asistencia',
            builder: (_, state) {
              return AsistenciaCreateScreen(
                periodoId: int.parse(state.pathParameters['periodoId']!),
                cursoId: int.parse(state.pathParameters['cursoId']!),
                paraleloId: int.parse(state.pathParameters['paraleloId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              );
            },
          ),
          // Agendas
          GoRoute(
            path:
                '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId/agendas',
            builder: (_, state) {
              return AgendaListScreen(
                periodoId: int.parse(state.pathParameters['periodoId']!),
                cursoId: int.parse(state.pathParameters['cursoId']!),
                paraleloId: int.parse(state.pathParameters['paraleloId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              );
            },
            routes: [
              // CREAR AGENDA
              GoRoute(
                path: 'create',

                builder: (_, state) {
                  return AgendaCreateScreen(
                    periodoId: int.parse(state.pathParameters['periodoId']!),

                    asignacionId: int.parse(
                      state.pathParameters['asignacionId']!,
                    ),
                    cursoId: int.parse(state.pathParameters['cursoId']!),
                    paraleloId: int.parse(state.pathParameters['paraleloId']!),
                  );
                },
              ),
              GoRoute(
                path: ':agendaId',

                builder: (_, state) {
                  return AgendaDetailScreen(
                    agendaId: int.parse(state.pathParameters['agendaId']!),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path:
                '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId/criterios',
            builder: (_, state) {
              return CriterioScreen(
                periodoId: int.parse(state.pathParameters['periodoId']!),
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              );
            },
          ),
          GoRoute(
            path:
                '/mis-clases/:periodoId/:cursoId/:paraleloId/:asignacionId/libro-calificaciones',
            builder: (_, state) {
              return LibroCalificacionesScreen(
                asignacionId: int.parse(state.pathParameters['asignacionId']!),
              );
            },
          ), */
        ],
      ),
    ],
  );

  return _routerInstance;
}
