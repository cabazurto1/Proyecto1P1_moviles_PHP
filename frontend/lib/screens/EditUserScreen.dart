import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class EditUserScreen extends StatefulWidget {
  final User user;
  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Inicializamos los campos con los datos actuales del usuario
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _passwordController.text = widget.user.password;
    _birthDateController.text = widget.user.birthDate;
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        birthDate: _birthDateController.text.trim(),
      );

      final response = await apiService.updateUser(updatedUser);

      if (response['message'] == 'Usuario actualizado') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario actualizado con éxito')),
        );
        Navigator.pop(context, updatedUser); // Volver con el usuario actualizado
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el usuario: ${response['message']}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF5C6E6E),
        foregroundColor: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
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
                      _birthDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF1DEBD),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Actualizar', style: TextStyle(fontSize: 18, color: Color(0xFF331B3B))),
                  ),
                ),
              ],
            ),
          ),
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
        prefixIcon: icon != null ? Icon(icon, color: Color(0xFF331B3B)) : null,
        filled: true,
        fillColor: Color(0xFFF1DEBD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
