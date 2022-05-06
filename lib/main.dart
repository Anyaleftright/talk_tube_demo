import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:talk_tube/app_theme.dart';
import 'package:talk_tube/bindings/initial_binding.dart';
import 'package:talk_tube/screens/dashboard.dart';
import 'package:talk_tube/screens/splash_screen.dart';
import 'package:talk_tube/screens/user_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      getPages: [
        GetPage(name: Routes.SPLASH_SCREEN, page: () => const SplashScreen()),
        GetPage(name: Routes.DATA, page: () => const UserInfoScreen()),
        GetPage(name: Routes.DASHBOARD, page: () => const DashboardScreen()),
      ],
      initialRoute: Routes.SPLASH_SCREEN,
    );
  }
}

class Routes {
  static const String SPLASH_SCREEN = "/";
  static const String DATA = "/data";
  static const String DASHBOARD = "/dashboard";
}
