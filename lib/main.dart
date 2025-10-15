import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_mahasiswa/core/resources/data_local.dart';
import 'package:manage_mahasiswa/core/routes/route.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';
import 'package:manage_mahasiswa/features/Mahasiswa/presentation/pages/test.dart';
import 'package:manage_mahasiswa/injection_container.dart';
import 'package:manage_mahasiswa/observer.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await dotenv.load(fileName: "assets/.env");
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';

  bool isLoggedIn = await getLoginStatus();

  final appRouter = AppRouter(isLoggedIn: isLoggedIn);

  await init();
  Bloc.observer = ObserverBloc();

  // runApp(const MaterialApp(
  //   home: DashboardScreen(),
  //   debugShowCheckedModeBanner: false,
  // ));
  runApp(MyApp(router: appRouter.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
      routerConfig: router,
    );
  }
}
