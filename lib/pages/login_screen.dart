import 'package:brackets/components/auth/auth_state.dart';
import 'package:brackets/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
  bool _isLoginWithPassword = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<void> _signInMagicLink() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(
        email: _emailController.text,
        options: AuthOptions(
            redirectTo: kIsWeb
                ? null
                : 'io.supabase.flutterquickstart://login-callback/'));
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Check your email for login link!');
      _emailController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signInPassword() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Success');
      _emailController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          _isLoginWithPassword
              ? const Text('Sign in via your credentials below')
              : const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          Visibility(
              visible: _isLoginWithPassword,
              child: Column(children: [
                const SizedBox(height: 18),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              ])),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.blueAccent.shade200)),
                  onPressed: _isLoading
                      ? null
                      : (_isLoginWithPassword
                          ? _signInPassword
                          : _signInMagicLink),
                  child: Text(_isLoading
                      ? 'Loading'
                      : (_isLoginWithPassword ? 'Log in' : 'Send Magic Link')),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade700)),
                  onPressed: () {
                    setState(() {
                      _isLoginWithPassword = !_isLoginWithPassword;
                    });
                  },
                  child: _isLoginWithPassword
                      ? const Text(
                          'Log in magic link',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Log in with password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/signup', (route) => false);
            },
            child: const Text('Sign up'),
          )
        ],
      ),
    );
  }
}
