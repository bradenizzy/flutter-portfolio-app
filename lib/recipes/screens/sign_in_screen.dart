// sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_portfolio_app/recipes/services/auth_service.dart';
import 'package:flutter_portfolio_app/recipes/widgets/sign_in/sign_in_form.dart';
import 'package:flutter_portfolio_app/recipes/widgets/sign_in/create_account_form.dart';
import 'package:flutter_portfolio_app/recipes/utils/firebase_error_util.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final authService = AuthService();
  //bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Sign In'),
            Tab(text: 'Create Account'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              SignInForm(
                emailController: _emailController,
                passwordController: _passwordController,
                onSignInPressed: () => _signInWithEmailAndPassword(context),
                onForgotPasswordPressed: _handleForgotPassword,
              ),
              CreateAccountForm(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                onCreateAccountPressed: () => _createAccount(context),
              ),
            ],
          ),
          // if (_isLoading) // Show loading indicator when _isLoading is true
          //   Container(
          //     color: Color.fromRGBO(0, 0, 0, 0.5), // Semi-transparent background
          //     child: Center(child: CircularProgressIndicator()),
          //   ),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushNamed(context, '/recipe');
      }
    } on FirebaseAuthException catch (e) {
      ErrorUtil.showSnackBar(context, ErrorUtil.getErrorMessage(e));
    } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    }
  }

  // TODO: SOMETHING GOING WRONG HERE NOT MOVING TO THE NEXT SCREEN
  Future<void> _createAccount(BuildContext context) async {
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      await authService.createAccount(
        _emailController.text,
        _passwordController.text,
        _firstNameController.text,
        _lastNameController.text,
        _phoneController.text,
      );
      if (mounted) {
        Navigator.pushNamed(context, '/recipe');
      }
    } on FirebaseAuthException catch (e) {
      ErrorUtil.showSnackBar(context, ErrorUtil.getErrorMessage(e));
    } //finally {
      // setState(() {
      //   _isLoading = false;
      // });
    //}
  }

  void _handleForgotPassword(String email) {
    if (email.isNotEmpty) {
      authService.sendPasswordResetEmail(email).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password reset email sent!"),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error sending password reset email"),
          backgroundColor: Colors.red,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter your email address"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}