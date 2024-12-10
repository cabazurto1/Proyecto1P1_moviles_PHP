import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8080/api/user';
  final String auth = 'http://localhost:8080/api/auth';
  // Método para registrar un usuario
  Future<Map<String, dynamic>> registerUser(User user) async {
    final url = Uri.parse('$baseUrl/create.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      // Usuario creado con éxito
      return {"success": true, "message": "Usuario creado exitosamente."};
    } else if (response.statusCode == 400) {
      // Error de validación
      final errorData = json.decode(response.body);
      return {"success": false, "message": errorData["message"]};
    } else {
      // Otros errores
      return {"success": false, "message": "El correo ya está registrado."};
    }
  }


  // Método para obtener usuarios
  Future<List<User>> getUsers() async {
    final url = Uri.parse('$baseUrl/read.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener usuarios.');
    }
  }

  // Método de inicio de sesión
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('http://localhost:8080/api/auth/login.php');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      // Devolver el cuerpo de la respuesta decodificado
      return json.decode(response.body);
    } catch (e) {
      // Manejar cualquier error de red
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para actualizar un usuario
  Future<Map<String, dynamic>> updateUser(User user) async {
    final url = Uri.parse('$baseUrl/update.php');
    final response = await http.post(
      url,  // Cambiar PUT a POST
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      return {'message': error['message'] ?? 'Error al actualizar el usuario.'};
    }
  }


  Future<Map<String, dynamic>> deleteUser(String email) async {
    final url = Uri.parse('$baseUrl/delete.php?email=$email'); // Pasamos el email como parámetro en la URL
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['message'] == 'Usuario eliminado con éxito.') {
        return data;  // Retornamos la respuesta exitosa
      } else {
        throw Exception('Error al eliminar el usuario: ${data['message']}');
      }
    } else {
      throw Exception('Usuario eliminado con éxito');
    }
  }




}
