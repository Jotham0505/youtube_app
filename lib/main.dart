import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_clone_app/authentication/services/auth_service.dart';
import 'package:youtube_clone_app/authentication/services/navigation_service.dart';
import 'package:youtube_clone_app/authentication/utils.dart';
import 'package:youtube_clone_app/screens/Navigation_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );

}

Future<void> setup() async{
  await setupSupabse();
  await registerService();
}

class MyApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance;


   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService = _getIt.get<NavigationService>();
    final AuthService _authService = _getIt.get<AuthService>();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedItemColor: Colors.white),
      ),
      navigatorKey: _navigationService.navigatorkey,
      initialRoute: _authService.user != null ? "/login" : "/login",
      routes: _navigationService.routes,
    );
  }
}

