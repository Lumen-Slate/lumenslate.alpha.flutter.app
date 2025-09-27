import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';

class EmailSignInFormMobile extends StatefulWidget {
  const EmailSignInFormMobile({super.key});

  @override
  State<EmailSignInFormMobile> createState() => _EmailSignInFormMobileState();
}

class _EmailSignInFormMobileState extends State<EmailSignInFormMobile> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSignUp = false;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleSignUpMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_isSignUp) {
        context.read<AuthBloc>().add(
          EmailSignUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          EmailSignIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  void _sendPasswordResetEmail() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      SendPasswordResetEmail(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent to ${state.email}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isSignUp ? 'Create Account' : 'Sign In with Email',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Name field (only shown for sign up)
              if (_isSignUp) ...[
                TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: GoogleFonts.poppins(),
                    prefixIcon: const Icon(Icons.person, size: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 16
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.email, size: 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 16
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.lock, size: 24),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      size: 24,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 16
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (_isSignUp && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is Loading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _isSignUp ? 'Create Account' : 'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),

              // Forgot password link (only for sign in)
              if (!_isSignUp) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _sendPasswordResetEmail,
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              
              // Toggle between sign in and sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp 
                        ? 'Already have an account? ' 
                        : "Don't have an account? ",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: _toggleSignUpMode,
                    child: Text(
                      _isSignUp ? 'Sign In' : 'Sign Up',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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