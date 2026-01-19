import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme/app_theme.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const PocketCaklempongApp());
}

/// Root application widget for Pocket Caklempong.
class PocketCaklempongApp extends StatelessWidget {
  const PocketCaklempongApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil: Design based on 360x800 (standard phone)
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Pocket Caklempong',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const HomeView(),
        );
      },
    );
  }
}
