import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/pages/login.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/pages/register.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/pages/verification.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/home.dart';

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
