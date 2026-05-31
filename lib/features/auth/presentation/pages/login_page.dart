import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/outer_shell.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_state.dart';
import 'package:TBConsult/features/auth/presentation/pages/register_page.dart';
import 'package:TBConsult/features/auth/presentation/widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => OuterShell()),
                  (_) => false,
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
              ));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),

                    // ── Logo + headline ────────────────────────────────
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 36),

                    const Text(
                      'Selamat datang\nkembali 👋',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk untuk melanjutkan perjalanan\npengobatan TB Anda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Email ──────────────────────────────────────────
                    AuthTextField(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'contoh@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email wajib diisi';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(v.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Password ───────────────────────────────────────
                    AuthTextField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: 'Masukkan password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: _submit,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        if (v.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Login button ───────────────────────────────────
                    AuthPrimaryButton(
                      label: 'Masuk',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),

                    const SizedBox(height: 28),

                    // ── Register prompt ────────────────────────────────
                    const AuthDivider(),
                    const SizedBox(height: 20),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'Belum punya akun? '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BlocProvider.value(
                                            value: context.read<AuthCubit>(),
                                            child: const RegisterPage(),
                                          ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Daftar sekarang',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── TBConsult branding note ────────────────────────
                    Center(
                      child: Text(
                        'TBConsult — Sistem Pendampingan TB',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
