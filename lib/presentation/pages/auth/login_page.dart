import 'package:flutter/material.dart';
import 'package:moneva/data/providers/auth_provider.dart';
import 'package:moneva/presentation/pages/home/home_page.dart';
import 'package:moneva/presentation/pages/auth/register_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                bool success = await authProvider.login(emailController.text, passwordController.text);
                if (success) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
                }
              },
              child: Text('Login'),
            ),
            TextButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => RegisterPage()),
  ),
  child: Text('Register'),
),

          ],
        ),
      ),
    );
  }
}
