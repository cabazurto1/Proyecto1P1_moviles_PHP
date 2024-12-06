import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8080/api/user';

  // Método para registrar un usuario
  Future<Map<String, dynamic>> registerUser(User user) async {
    final url = Uri.parse('$baseUrl/create.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return {'message': 'Error al crear el usuario.'};
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

  // Método para actualizar un usuario
  Future<Map<String, dynamic>> updateUser(User user) async {
    final url = Uri.parse('$baseUrl/update.php');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'message': 'Error al actualizar el usuario.'};
    }
  }
}
