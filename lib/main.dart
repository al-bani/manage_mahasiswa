import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/core/routes/route.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/test.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'package:manage_mahasiswa/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLoggedIn = await getLoginStatus();

  final appRouter = AppRouter(isLoggedIn: isLoggedIn);

  await init();
  Bloc.observer = ObserverBloc();
  // runApp( const TestScreen());
  runApp(MyApp(router: appRouter.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
