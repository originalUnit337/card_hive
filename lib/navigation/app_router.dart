// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:card_hive/core/ui_kit/error_screen/error_screen.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/card_info_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/edit_screen/card_info_edit_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/notes_screen/card_info_note_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/pictures_screen/card_info_pictures_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/home_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/add_premade_card/add_premade_card_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/scanner_screen/scanner_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/store_list_screen.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:card_hive/navigation/transitions/app_transitions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class AppRouter {
  final Logger _logger;
  final HomeBloc _homeBloc;
  final CardInfoBloc _cardInfoBloc;

  AppRouter(this._logger, this._homeBloc, this._cardInfoBloc);

  GoRouter get router => GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.homeRoute.path,
        name: AppRoutes.homeRoute.name,
        pageBuilder: (context, state) {
          return AppTransitions.getTransitionPage(
            BlocProvider.value(value: _homeBloc, child: const HomeScreen()),
          );
        },
        builder: (context, state) {
          _logger.d('Going to home screen');
          return BlocProvider.value(
            value: _homeBloc,
            child: const HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.cardInfo.path,
        name: AppRoutes.cardInfo.name,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is CardEntity) {
            return AppTransitions.getTransitionPage(
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _homeBloc),
                  BlocProvider.value(value: _cardInfoBloc),
                ],
                child: CardInfoScreen(card: extra),
              ),
            );
          } else {
            return AppTransitions.getTransitionPage(const ErrorScreen());
          }
        },
        builder: (context, state) {
          _logger.d('Going to card info screen');
          final extra = state.extra;
          if (extra is CardEntity) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _homeBloc),
                BlocProvider.value(value: _cardInfoBloc),
              ],
              child: CardInfoScreen(card: extra),
            );
          } else {
            return const ErrorScreen();
          }
        },
        routes: [
          GoRoute(
            path: 'notes',
            name: AppRoutes.cardInfoNotes.name,
            pageBuilder: (context, state) {
              return AppTransitions.getTransitionPage(
                const CardInfoNoteScreen(),
              );
            },
            builder: (context, state) {
              _logger.d('Going to card info notes screen');
              return const CardInfoNoteScreen();
            },
          ),
          GoRoute(
            path: 'pictures',
            name: AppRoutes.cardInfoPictures.name,
            pageBuilder: (context, state) {
              return AppTransitions.getTransitionPage(
                const CardInfoPicturesScreen(),
              );
            },
            builder: (context, state) {
              _logger.d('Going to card info pictures screen');
              return const CardInfoPicturesScreen();
            },
          ),
          GoRoute(
            path: 'edit',
            name: AppRoutes.cardInfoEdit.name,
            pageBuilder: (context, state) {
              final extra = state.extra;
              if (extra is CardEntity) {
                return AppTransitions.getTransitionPage(
                  CardInfoEditScreen(card: extra),
                );
              } else {
                return AppTransitions.getTransitionPage(const ErrorScreen());
              }
            },
            builder: (context, state) {
              _logger.d('Going to card info edit screen');
              final extra = state.extra;
              if (extra is CardEntity) {
                return CardInfoEditScreen(card: extra);
              } else {
                return const ErrorScreen();
              }
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.storeList.path,
        name: AppRoutes.storeList.name,
        pageBuilder:
            (context, state) =>
                AppTransitions.getTransitionPage(const StoreListScreen()),
        builder: (context, state) {
          _logger.d('Going to StoreListScreen');
          return const StoreListScreen();
        },
        routes: [
          GoRoute(
            path: AppRoutes.scannerScreen.path.split('/').last,
            name: AppRoutes.scannerScreen.name,
            pageBuilder: (context, state) {
              _logger.d('Going to ${AppRoutes.scannerScreen.name}');
              final extra = state.extra;
              if (extra is StoreEntity) {
                return AppTransitions.getTransitionPage(
                  ScannerScreen(store: extra),
                );
              } else {
                return AppTransitions.getTransitionPage(const ErrorScreen());
              }
            },
            builder: (context, state) {
              _logger.d('Going to ${AppRoutes.scannerScreen.name}');
              final extra = state.extra;
              if (extra is StoreEntity) {
                return ScannerScreen(store: extra);
              } else {
                return const ErrorScreen();
              }
            },
            routes: [
              GoRoute(
                path: AppRoutes.addPremadeCard.path.split('/').last,
                name: AppRoutes.addPremadeCard.name,
                pageBuilder: (context, state) {
                  _logger.d('Going to ${AppRoutes.addPremadeCard.name}');
                  final extra = state.extra;
                  if (extra is StoreEntity) {
                    return AppTransitions.getTransitionPage(
                      AddPremadeCardScreen(store: extra),
                    );
                  } else {
                    return AppTransitions.getTransitionPage(
                      const ErrorScreen(),
                    );
                  }
                },
                builder: (context, state) {
                  _logger.d('Going to ${AppRoutes.addPremadeCard.name}');
                  final extra = state.extra;
                  if (extra is StoreEntity) {
                    return AddPremadeCardScreen(store: extra);
                  } else {
                    return const ErrorScreen();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
