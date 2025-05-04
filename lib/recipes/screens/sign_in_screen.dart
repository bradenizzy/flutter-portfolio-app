
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter_portfolio_app/recipes/services/auth_service.dart';
import 'package:flutter_portfolio_app/recipes/providers/user_profile_provider.dart';
import 'package:flutter_portfolio_app/recipes/models/user_profile.dart';
import 'package:flutter_portfolio_app/recipes/widgets/sign_in/sign_in_form.dart';
import 'package:flutter_portfolio_app/recipes/widgets/sign_in/create_account_form.dart';
import 'package:flutter_portfolio_app/recipes/utils/firebase_error_util.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _phoneController     = TextEditingController();
  final authService = AuthService();
  bool _isLoading = false;

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
          if (_isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      // Sign in AND fetch the user profile in one go:
      UserProfile profile = await authService.signInWithEmailAndReturnProfile(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Store it in the provider:
      Provider.of<UserProfileProvider>(context, listen: false)
          .setUserProfile(profile);

      // Navigate into the app
      if (mounted) Navigator.pushNamed(context, '/recipe');
    } on FirebaseAuthException catch (e) {
      ErrorUtil.showSnackBar(context, ErrorUtil.getErrorMessage(e));
    } catch (e) {
      // any other errors (e.g. profile-not-found)
      ErrorUtil.showSnackBar(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createAccount(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      // Create auth record + initial Firestore profile:
      await authService.createAccount(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _phoneController.text.trim(),
      );

      // Now that the user is signed in, fetch their full profile:
      UserProfile profile = await authService.signInWithEmailAndReturnProfile(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      Provider.of<UserProfileProvider>(context, listen: false)
          .setUserProfile(profile);

      if (mounted) Navigator.pushNamed(context, '/recipe');
    } on FirebaseAuthException catch (e) {
      ErrorUtil.showSnackBar(context, ErrorUtil.getErrorMessage(e));
    } catch (e) {
      ErrorUtil.showSnackBar(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleForgotPassword(String email) {
    if (email.isEmpty) {
      ErrorUtil.showSnackBar(context, "Please enter your email address");
      return;
    }
    authService.sendPasswordResetEmail(email).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent!"), backgroundColor: Colors.green),
      );
    }).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending password reset email"), backgroundColor: Colors.red),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

// // sign_in_screen.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_portfolio_app/recipes/services/auth_service.dart';
// import 'package:flutter_portfolio_app/recipes/widgets/sign_in/sign_in_form.dart';
// import 'package:flutter_portfolio_app/recipes/widgets/sign_in/create_account_form.dart';
// import 'package:flutter_portfolio_app/recipes/utils/firebase_error_util.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final authService = AuthService();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: 'Sign In'),
//             Tab(text: 'Create Account'),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           TabBarView(
//             controller: _tabController,
//             children: [
//               SignInForm(
//                 emailController: _emailController,
//                 passwordController: _passwordController,
//                 onSignInPressed: () => _signInWithEmailAndPassword(context),
//                 onForgotPasswordPressed: _handleForgotPassword,
//               ),
//               CreateAccountForm(
//                 firstNameController: _firstNameController,
//                 lastNameController: _lastNameController,
//                 emailController: _emailController,
//                 phoneController: _phoneController,
//                 passwordController: _passwordController,
//                 confirmPasswordController: _confirmPasswordController,
//                 onCreateAccountPressed: () => _createAccount(context),
//               ),
//             ],
//           ),
//           if (_isLoading) // Show loading indicator when _isLoading is true
//             Container(
//               color: Color.fromRGBO(0, 0, 0, 0.5), // Semi-transparent background
//               child: Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<void> _signInWithEmailAndPassword(BuildContext context) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await authService.signInWithEmailAndPassword(
//         _emailController.text,
//         _passwordController.text,
//       );
//       if (mounted) {
//         // TODO: this should eventually not be allowed to go back after entering the app
//         Navigator.pushNamed(context, '/recipe');
//       }
//     } on FirebaseAuthException catch (e) {
//       ErrorUtil.showSnackBar(context, ErrorUtil.getErrorMessage(e));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _createAccount(BuildContext context) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await authService.createAccount(
//         _emailController.text,
//         _passwordController.text,
//         _firstNameController.text,
//         _lastNameController.text,
//         _phoneController.text,
//       );
//       // Check if the user is signed in
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         if (mounted) {
//           // TODO: this should eventually not be allowed to go back after entering the app
//           Navigator.pushNamed(context, '/recipe');
//         } else {
//           ErrorUtil.showSnackBar(context, "Account created, but user is not signed in.");
//         }
//       } else {
//         ErrorUtil.showSnackBar(context, "Account created, but user is not signed in.");
//       }
//     } on FirebaseAuthException catch (e) {
//       ErrorUtil.showSnackBar(context, ErrorUtil.getErrorMessage(e));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _handleForgotPassword(String email) {
//     if (email.isNotEmpty) {
//       authService.sendPasswordResetEmail(email).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("Password reset email sent!"),
//           backgroundColor: Colors.green,
//         ));
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("Error sending password reset email"),
//           backgroundColor: Colors.red,
//         ));
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Please enter your email address"),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }