import 'package:card_hive/features/cards/presentation/theme/app_theme.dart';
import 'package:card_hive/injection_container.dart';
import 'package:card_hive/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightAppTheme,
      darkTheme: AppTheme.darkAppTheme,
      routerConfig: AppRouter(Logger()).router,
    );
  }
}
