import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moneva/data/providers/auth_provider.dart';
import 'package:moneva/presentation/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      setState(() {
                        _isLoading = true;
                      });

                      bool success = await authProvider.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _roleController.text,
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      if (success) {
                        // Redirect ke halaman login jika berhasil
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.errorMessage!)),
                        );
                      }
                    },
                    child: const Text("Register"),
                  ),
          ],
        ),
      ),
    );
  }
}
