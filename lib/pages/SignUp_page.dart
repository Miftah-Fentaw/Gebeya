import 'package:gebeya/constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gebeya/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              phoneController: _phoneController,
              obscurePassword: _obscurePassword,
              obscureConfirmPassword: _obscureConfirmPassword,
              onTogglePassword: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              onToggleConfirmPassword: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const Elements({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // Responsive padding
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 238, 231, 231),
                        fontSize: MediaQuery.of(context).size.width * 0.2, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
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
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      hintText: 'Enter your phone number',
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: onToggleConfirmPassword,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06, // Responsive height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: authProvider.isLoading ? null : () async {
                        if (formKey.currentState!.validate()) {
                          final success = await authProvider.signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text,
                            name: nameController.text.trim(),
                            phoneNumber: phoneController.text.trim().isNotEmpty 
                                ? phoneController.text.trim() 
                                : null,
                          );
                          
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/Main_Page');
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage ?? 'Sign up failed'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(color: secondaryColor)
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Center(
                      child: Text(
                        'Already have an account? Sign In.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.075, // Responsive font size
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
                      child: Text(
                        'continue as guest >>',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}