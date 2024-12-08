import 'package:flutter/material.dart';
import 'package:frontend/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/LoginScreen.dart';
import 'screens/home_screen.dart';
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
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(), // Ruta de pantalla principal
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen(); // Redirigir a HomeScreen si el token está presente
          } else {
            return LoginScreen(); // Redirigir a LoginScreen si no hay token
          }
        }
      },
    );
  }

  // Verificar si el token está guardado
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null; // Si el token existe, se considera como usuario autenticado
  }
}
