import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../core/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isRegister = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) context.go('/home');
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Row(
                  children: [
                    const Icon(Icons.forest, color: AppTheme.forestGreen, size: 36),
                    const SizedBox(width: 8),
                    const Text(
                      'CampsiteMY',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.forestGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isRegister ? 'Create your account' : 'Welcome back',
                  style: const TextStyle(fontSize: 16, color: AppTheme.greyText),
                ),
                const SizedBox(height: 40),

                // Google Sign In
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;
                    return OutlinedButton(
                      onPressed: loading
                          ? null
                          : () => context.read<AuthBloc>().add(AuthGoogleSignInRequested()),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFDEE2E6)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.google.com/favicon.ico',
                            width: 20,
                            height: 20,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.g_mobiledata, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Text('Continue with Google',
                              style: TextStyle(color: AppTheme.darkText, fontSize: 15)),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                Row(children: [
                  const Expanded(child: Divider()),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: TextStyle(color: AppTheme.greyText)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 24),

                if (_isRegister) ...[
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;
                    return ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52)),
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(_isRegister ? 'Create Account' : 'Sign In'),
                    );
                  },
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _isRegister = !_isRegister),
                    child: Text(
                      _isRegister
                          ? 'Already have an account? Sign in'
                          : 'Don\'t have an account? Register',
                      style: const TextStyle(color: AppTheme.forestGreen),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (_isRegister) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(_nameCtrl.text.trim(), email, pass),
          );
    } else {
      context.read<AuthBloc>().add(AuthEmailSignInRequested(email, pass));
    }
  }
}
