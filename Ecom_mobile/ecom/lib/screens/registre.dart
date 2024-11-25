import 'package:flutter/material.dart';
import 'package:ecom/services/auth_service.dart';
import 'package:ecom/routes/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = {
        "username": _usernameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "address": _addressController.text.trim(),
        "phone": _phoneController.text.trim(),
      };

      final response = await _authService.register(userData);

      // Si inscription réussie
      if (response.isNotEmpty) {
         Fluttertoast.showToast(
        msg: "Account created successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromARGB(255, 182, 123, 123),
        textColor: Colors.white,
        fontSize: 16.0
    );
        _showSuccessDialog("Account created successfully. Please log in.");
        Navigator.pushNamed(context, AppRoutes.login);
      }
    } catch (error) {
      _showErrorDialog("Registration failed: ${error.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Okay"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Okay"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.blue.shade100,
        filled: true,
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: const [
                  SizedBox(height: 60.0),
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create your account",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  _buildTextField(_usernameController, "Username", Icons.person),
                  const SizedBox(height: 20),
                  _buildTextField(_emailController, "Email", Icons.email),
                  const SizedBox(height: 20),
                  _buildTextField(
                    _passwordController,
                    "Password",
                    Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_addressController, "Address", Icons.home),
                  const SizedBox(height: 20),
                  _buildTextField(_phoneController, "Phone", Icons.phone),
                ],
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signup,
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade400,
                      ),
                    ),
              const Center(child: Text("Or")),
              OutlinedButton.icon(
                onPressed: () {
                  // Logic for Google authentication
                },
                icon: const Icon(Icons.g_mobiledata, color: Colors.blue),
                label: const Text(
                  "Sign up with Google",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  shape: const StadiumBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}