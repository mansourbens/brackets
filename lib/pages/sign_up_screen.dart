import 'package:brackets/utils/constants.dart';
import 'package:brackets/utils/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isPasswordObscure = true;
  final _formKey = GlobalKey<FormState>();
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    print(_emailController.text);
    final response = await supabase.auth.signUp(
        _emailController.text, _passwordController.text,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterquickstart://login-callback/'));
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(
          message: 'Your account is created, please verify your email !');
      _emailController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign up using email and password'),
          const SizedBox(height: 18),
          Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) => emailValidator(value),
                    controller: _emailController,
                    decoration: buildInputDecoration('Email', null),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: _isPasswordObscure,
                    textInputAction: TextInputAction.next,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    decoration:
                        buildInputDecoration('Password', buildIconButton()),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: _isPasswordObscure,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (_passwordController.text != value) {
                        return 'Passwords don\'t match';
                      }
                      return null;
                    },
                    decoration: buildInputDecoration(
                        'Confirm password', buildIconButton()),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        _isLoading ? null : _signUp();
                      }
                    },
                    child: const Text('Sign up'),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blueGrey.shade400,
                      ),
                    ),
                    child: const Text('Return'),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  IconButton buildIconButton() {
    return IconButton(
      icon: Icon(_isPasswordObscure ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          _isPasswordObscure = !_isPasswordObscure;
        });
      },
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isEmailValid(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
