import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/pages/login.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/pages/register.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/pages/verification.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/create.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/detail.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/home.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/update.dart';

class AppRouter {
  final bool isLoggedIn;
  AppRouter({required this.isLoggedIn});

  get router => GoRouter(
        initialLocation: isLoggedIn ? '/home' : '/auth/login',
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/detail',
            name: 'detail',
            pageBuilder: (context, state) {
              final int id = state.extra as int; // Ensure you're passing an int
              return NoTransitionPage(
                child: DetailScreen(id), // Pass id to DetailScreen
              );
            },
          ),
          GoRoute(
            path: '/update',
            name: 'update',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UpdateScreen(),
            ),
          ),
          GoRoute(
            path: '/create',
            name: 'create',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CreateScreen(),
            ),
          ),
          GoRoute(
            path: '/auth', // Menghapus slash di akhir path
            redirect: (context, state) => isLoggedIn ? '/home' : null,
            routes: [
              GoRoute(
                path: 'login',
                name: 'login',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: LoginScreen()),
              ),
              GoRoute(
                path: 'register',
                name: 'register',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: RegisterScreen()),
              ),
              GoRoute(
                path: 'verification',
                name: 'verification',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: VerificationScreen(state.extra as String),
                ),
              ),
            ],
          ),
        ],
      );
}
