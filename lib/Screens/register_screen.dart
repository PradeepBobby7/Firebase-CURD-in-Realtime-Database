import 'package:firebase_curd/Screens/home_screen.dart';
import 'package:firebase_curd/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confrimPassController = TextEditingController();
  bool isLoading = false;

  void register() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confrimPassword = confrimPassController.text.trim();
    if (password != confrimPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("your both are password mismatch !, Enter correctly ."),
        ),
      );
      return;
    }
    setState(() => isLoading = true);
    String? result = await authProvider.signUp(email, password);
    setState(() => isLoading = false);
    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            TextField(
              controller: confrimPassController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "ConfirmPassword", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: const Text("Register"),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Already Have a Account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
