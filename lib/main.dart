import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbcare/outer_shell.dart';
import 'core/theme/app_colors.dart';
import 'features/treatment/presentation/pages/treatment_dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const TBCareApp());
}

class TBCareApp extends StatelessWidget {
  const TBCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TBCare',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        fontFamily: 'Plus Jakarta Sans',
      ),
      home: const OuterShell(),
    );
  }
}