import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String email;
  final String password;
  final String birthDate;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.birthDate,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Desconocido',  // Valor por defecto si es null
      email: json['email'] ?? 'Sin correo',
      password: json['password'] ?? 'Sin contraseña',
      birthDate: json['birth_date'] ?? 'Sin fecha de nacimiento',
    );
  }
  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birth_date': birthDate,
    };
  }

  // Método para convertir credenciales de login a JSON
  Map<String, dynamic> toLoginJson() {
    return {
      'email': email,
      'password': password,
    };
  }


}
