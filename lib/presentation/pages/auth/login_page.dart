import 'package:flutter/material.dart';
import 'package:moneva/data/providers/auth_provider.dart';
import 'package:moneva/presentation/pages/home/main_screen.dart';
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
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 16),

                // Jika sedang loading, tampilkan loading indicator
                authProvider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                final authProvider =
                                    Provider.of<AuthProvider>(context, listen: false);

                                bool success = await authProvider.login(
                                  emailController.text,
                                  passwordController.text,
                                );

                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => MainScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Login gagal: ${authProvider.errorMessage ?? "Terjadi kesalahan"}')),
                                  );
                                }
                              },
                        child: Text('Login'),
                      ),

                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  ),
                  child: Text('Register'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
