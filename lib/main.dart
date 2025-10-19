import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
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
  final homeBloc = HomeBloc(getIt(), getIt())..add(const GetAllCardsEvent());
  final cardInfoBloc = CardInfoBloc(getIt(), getIt());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeBloc),
        BlocProvider.value(value: cardInfoBloc),
      ],
      child: MainApp(homeBloc: homeBloc, cardInfoBloc: cardInfoBloc),
    ),
  );
}

class MainApp extends StatelessWidget {
  final HomeBloc homeBloc;
  final CardInfoBloc cardInfoBloc;
  const MainApp({
    required this.homeBloc,
    required this.cardInfoBloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightAppTheme,
      darkTheme: AppTheme.darkAppTheme,
      routerConfig: AppRouter(Logger(), homeBloc, cardInfoBloc).router,
    );
  }
}
