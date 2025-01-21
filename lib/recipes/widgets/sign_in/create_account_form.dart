// create_account_form.dart

import 'package:flutter/material.dart';

class CreateAccountForm extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onCreateAccountPressed;

  const CreateAccountForm({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onCreateAccountPressed,
  }) : super(key: key);

  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool? _isPasswordMatched;

  void _checkPasswordsMatch() {
    if (widget.passwordController.text.isEmpty && widget.confirmPasswordController.text.isEmpty) {
      _isPasswordMatched = null; 
    } else if (widget.passwordController.text == widget.confirmPasswordController.text) {
      _isPasswordMatched = true;
    } else {
      _isPasswordMatched = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: widget.firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: widget.lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          // SizedBox(height: 16),
          // TextField(             // TODO: add phone?
          //   controller: phoneController,
          //   decoration: InputDecoration(
          //     labelText: 'Phone Number (Optional)',
          //     border: OutlineInputBorder(),
          //     ),
          //   keyboardType: TextInputType.phone,
          // ),
          SizedBox(height: 16),
          TextField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            onChanged: (_) => _checkPasswordsMatch(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: widget.confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            obscureText: _obscureConfirmPassword,
            onChanged: (_) => _checkPasswordsMatch(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPasswordMatched == null ? Icons.info_outline :
                  (_isPasswordMatched == true ? Icons.check_circle : Icons.error_outline),
                  color: _isPasswordMatched == null ? Colors.grey :
                  (_isPasswordMatched == true ? Colors.green : Colors.red),
                ),
                SizedBox(width: 8),
                Text(
                  _isPasswordMatched == null ? "Please enter a password" :
                  (_isPasswordMatched == true ? "Passwords match" : "Passwords do not match"),
                  style: TextStyle(
                    color: _isPasswordMatched == null ? Colors.grey :
                    (_isPasswordMatched == true ? Colors.green : Colors.red),
                  )
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Create Account'),
            onPressed: _isPasswordMatched == true
              ? () {
                  widget.onCreateAccountPressed();
                }
              : null,
          ),
        ],
      ),
    );
  }
}

