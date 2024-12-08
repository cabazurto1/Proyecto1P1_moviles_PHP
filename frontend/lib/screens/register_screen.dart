import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para manejar el formato de fechas
import '../models/user.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  final ApiService apiService = ApiService();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Convertir la fecha al formato YYYY-MM-DD
      final inputDate = _birthDateController.text;
      final parsedDate = DateFormat('dd-MM-yyyy').parse(inputDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        birthDate: formattedDate,
      );

      final response = await apiService.registerUser(user);
      if (response['message'] == 'Usuario creado exitosamente.') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          'Crea tu cuenta',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Claro para contraste
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Llena los campos a continuación para registrarte.',
                          style: TextStyle(fontSize: 16, color: Color(0xFFF1DEBD)),
                        ),
                        const SizedBox(height: 30),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nombre',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Correo Electrónico',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El correo electrónico es obligatorio';
                            }
                            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Ingresa un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Contraseña',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La contraseña es obligatoria';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _birthDateController,
                          label: 'Fecha de Nacimiento (DD-MM-YYYY)',
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              _birthDateController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La fecha de nacimiento es obligatoria';
                            }
                            try {
                              DateFormat('dd-MM-yyyy').parse(value);
                            } catch (_) {
                              return 'El formato de la fecha es incorrecto';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF1DEBD), // Fondo claro
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Bordes redondeados
                              ),
                            ),
                            child: const Text(
                              'Registrar',
                              style: TextStyle(fontSize: 18, color: Color(0xFF331B3B)), // Color oscuro
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '¿Ya tienes una cuenta? Inicia sesión',
                              style: TextStyle(
                                color: Colors.white, // Color oscuro
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Color(0xFF331B3B)) : null, // Color de los iconos
        filled: true,
        fillColor: Color(0xFFF1DEBD), // Fondo claro
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
