import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<User> users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadUsers();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');  // Recuperamos el token guardado

    if (token == null) {
      // Si no hay token, redirige a la pantalla de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _loadUsers() async {
    try {
      List<User> userList = await apiService.getUsers();
      setState(() {
        users = userList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los usuarios: $e')),
      );
    }
  }

  void _editUser(User user) {
    // Implementar lógica para editar el usuario
    // Podrías navegar a otra pantalla de edición de usuario
  }

  void _deleteUser(String email) async {
    try {
      final response = await apiService.deleteUser(email);
      if (response['message'] == 'Usuario eliminado') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario eliminado')),
        );
        _loadUsers(); // Recargar la lista de usuarios después de eliminar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el usuario')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el usuario: $e')),
      );
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');  // Eliminar el token

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),  // Redirigir a login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5C6E6E), // Color de fondo más suave
        title: Text('Lista de Usuarios', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: _logout,  // Llamamos a la función de cerrar sesión
              ),
              TextButton(
                onPressed: _logout,
                child: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF331B3B), // Color oscuro de la paleta
              Color(0xFF5C6E6E), // Gris suave
              Color(0xFF333E50), // Otro tono oscuro
            ],
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF331B3B),
                    child: Text(user.name[0].toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(user.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: Text(user.email, style: TextStyle(color: Colors.grey)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF331B3B)),
                        onPressed: () => _editUser(user),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteUser(user.email),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
