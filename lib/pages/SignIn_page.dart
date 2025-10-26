import 'package:gebeya/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gebeya/providers/auth_provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/auth_cover.jpg', 
                fit: BoxFit.cover,    
              ),
            ),
            Elements(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              onTogglePassword: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Elements extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const Elements({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: onTogglePassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: authProvider.isLoading ? null : () async {
                      if (formKey.currentState!.validate()) {
                        final success = await authProvider.signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                        
                        if (success && context.mounted) {
                          Navigator.pushReplacementNamed(context, '/Main_Page');
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(authProvider.errorMessage ?? 'Sign in failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: authProvider.isLoading
                        ? CircularProgressIndicator(color: secondaryColor)
                        : const Text(
                            'LogIn',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      if (emailController.text.isNotEmpty) {
                        final success = await authProvider.resetPassword(emailController.text.trim());
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success 
                                ? 'Password reset email sent' 
                                : authProvider.errorMessage ?? 'Failed to send reset email'),
                              backgroundColor: success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter your email first'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Center(
                    child: const Text(
                      'Create New Account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final success = await authProvider.signInAsGuest();
                    if (success && context.mounted) {
                      Navigator.pushReplacementNamed(context, '/Main_Page');
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.errorMessage ?? 'Guest sign in failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Center(
                    child: const Text(
                      'continue as guest >>',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}