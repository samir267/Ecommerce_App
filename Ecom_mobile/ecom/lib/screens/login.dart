import 'package:flutter/material.dart';
import 'package:ecom/routes/app_routes.dart';
import 'package:ecom/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print('Login failed: One or both fields are empty.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting login process for email: $email');
      await _authService.login(email, password);

      if (mounted) {
        Fluttertoast.showToast(
        msg: "Login successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromARGB(255, 182, 123, 123),
        textColor: Colors.white,
        fontSize: 16.0
    );
        print('Login successful. Redirecting to home...');
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (error) {
      print('Login failed with error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            _header(),
            const SizedBox(height: 30),
            _inputFields(),
            const SizedBox(height: 10),
            _forgotPassword(),
            const SizedBox(height: 20),
            _loginButton(),
            const SizedBox(height: 20),
            _signup(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Enter your credentials to login",
          style:  TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.blue.shade50,
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.blue.shade50,
            filled: true,
            prefixIcon: const Icon(Icons.lock),
          ),
          obscureText: true,
        ),
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        print('Forgot password pressed.');
        // Logique pour réinitialiser le mot de passe
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue.shade400,
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const Text(
              "Login",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            print('Navigating to Sign Up page.');
            Navigator.pushNamed(context, AppRoutes.registre);
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}