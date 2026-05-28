import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/outer_shell.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_state.dart';
import 'package:TBConsult/features/auth/presentation/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Minimum time the splash is shown so the animation completes nicely.
  static const _minSplashDuration = Duration(milliseconds: 2800);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 6),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Run the auth check and the minimum display time in parallel,
    // then navigate only when BOTH are done.
    _bootstrapAndNavigate();
  }

  Future<void> _bootstrapAndNavigate() async {
    // Wait for both: the splash animation hold AND the auth status check.
    await Future.wait([
      Future.delayed(_minSplashDuration),
      context.read<AuthCubit>().checkAuthStatus(),
    ]);
    // Navigation is handled reactively by BlocListener in build().
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OuterShell()),
          );
        }
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AuthCubit>(),
                child: const LoginPage(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.background,
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Image.asset('assets/images/logo.png', width: 160),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
