import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_state.dart';
import 'package:TBConsult/features/auth/presentation/widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().register(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      fullName: _nameCtrl.text.trim().isEmpty
          ? null
          : _nameCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(
                    'Akun berhasil dibuat! Silakan masuk, ${state.user.displayName}.'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ));
            // Go back to login
            Navigator.pop(context);
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
                    const SizedBox(height: 8),

                    // ── Headline ───────────────────────────────────────
                    const Text(
                      'Buat akun baru ✨',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Daftar untuk mulai memantau\nperjalanan pengobatan TB Anda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Full name (optional) ───────────────────────────
                    AuthTextField(
                      controller: _nameCtrl,
                      label: 'Nama Lengkap (opsional)',
                      hint: 'Nama Anda',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                    ),

                    const SizedBox(height: 16),

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
                      hint: 'Minimal 8 karakter',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_confirmFocus),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password wajib diisi';
                        if (v.length < 8) return 'Password minimal 8 karakter';
                        if (!RegExp(r'[A-Z]').hasMatch(v)) {
                          return 'Harus mengandung minimal satu huruf kapital';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(v)) {
                          return 'Harus mengandung minimal satu angka';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Confirm password ───────────────────────────────
                    AuthTextField(
                      controller: _confirmCtrl,
                      label: 'Konfirmasi Password',
                      hint: 'Ulangi password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: _submit,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Konfirmasi password wajib diisi';
                        }
                        if (v != _passwordCtrl.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // ── Password strength hint ─────────────────────────
                    _PasswordHint(password: _passwordCtrl.text),

                    const SizedBox(height: 28),

                    // ── Register button ────────────────────────────────
                    AuthPrimaryButton(
                      label: 'Daftar',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),

                    const SizedBox(height: 24),

                    // ── Login prompt ───────────────────────────────────
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textSecondary),
                          children: [
                            const TextSpan(text: 'Sudah punya akun? '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                child: const Text(
                                  'Masuk',
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

/// Small live password-strength indicator shown below the password field.
class _PasswordHint extends StatelessWidget {
  final String password;
  const _PasswordHint({required this.password});

  @override
  Widget build(BuildContext context) {
    final hasLength = password.length >= 8;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HintRow(met: hasLength, label: 'Minimal 8 karakter'),
        const SizedBox(height: 4),
        _HintRow(met: hasUpper, label: 'Mengandung huruf kapital'),
        const SizedBox(height: 4),
        _HintRow(met: hasNumber, label: 'Mengandung angka'),
      ],
    );
  }
}

class _HintRow extends StatelessWidget {
  final bool met;
  final String label;
  const _HintRow({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: met ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: met ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
