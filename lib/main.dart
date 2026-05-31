import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'package:TBConsult/core/di/injection_container.dart' as di;
import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:TBConsult/features/splash/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.init();

  if (Platform.isAndroid) {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      await mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
    }
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const TBConsultApp());
}

class TBConsultApp extends StatelessWidget {
  const TBConsultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      // AuthCubit lives at the root so splash, login, register, and
      // OuterShell can all share it via context.read<AuthCubit>().
      create: (_) => di.sl<AuthCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TBConsult',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            surface: AppColors.background,
          ),
          fontFamily: 'Plus Jakarta Sans',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
