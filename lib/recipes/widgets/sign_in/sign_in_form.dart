// sign_in_form.dart

import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignInPressed;
  final Function(String) onForgotPasswordPressed;

  const SignInForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onSignInPressed,
    required this.onForgotPasswordPressed,
  }) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _obscurePassword = true; // State variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // SizedBox(height: 20),
          // Image.asset('assets/logo.png'), //TODO: Make sure to have a logo asset
          SizedBox(height: 40),
          TextField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ), 
          SizedBox(height: 16),
          TextField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  // Change the icon based on whether the password is obscured
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Update the state to toggle password visibility
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Sign In'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: widget.onSignInPressed,
          ),
          TextButton(
            onPressed: () => widget.onForgotPasswordPressed(widget.emailController.text),
            child: Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }
}