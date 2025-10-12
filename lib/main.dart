import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:card_hive/features/cards/presentation/theme/app_theme.dart';
import 'package:card_hive/injection_container.dart';
import 'package:card_hive/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  final homeBloc = HomeBloc(getIt(), getIt(), getIt())..add(const GetAllCardsEvent());
  runApp(
    BlocProvider.value(
      value: homeBloc,
      child: MainApp(homeBloc: homeBloc,),
    ),
  );
}

class MainApp extends StatelessWidget {
  final HomeBloc homeBloc;
  const MainApp({required this.homeBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightAppTheme,
      darkTheme: AppTheme.darkAppTheme,
      routerConfig: AppRouter(Logger(), homeBloc).router,
    );
  }
}
