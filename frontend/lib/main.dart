import 'package:flutter/material.dart';
import 'package:frontend/screens/LoginScreen.dart';
import 'screens/main_page.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const MainPage(), // Ruta de pantalla principal
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(), // Ruta de pantalla de registro
      },
    );
  }
}
