import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'viewmodels/caklempong_viewmodel.dart';
import 'views/caklempong_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for optimal instrument layout
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
    return ChangeNotifierProvider(
      create: (_) => CaklempongViewModel(),
      child: MaterialApp(
        title: 'Pocket Caklempong',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const CaklempongView(),
      ),
    );
  }
}
