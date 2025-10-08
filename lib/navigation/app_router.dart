// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:card_hive/core/ui_kit/error_screen/error_screen.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/card_info_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/edit_screen/card_info_edit_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/notes_screen/card_info_note_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/pictures_screen/card_info_pictures_screen.dart';
import 'package:card_hive/features/cards/presentation/screens/home/home_screen.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:card_hive/navigation/transitions/app_transitions.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class AppRouter {
  final Logger _logger;

  AppRouter(this._logger);

  GoRouter get router => GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.homeRoute.path,
        name: AppRoutes.homeRoute.name,
        pageBuilder: (context, state) {
          return AppTransitions.getTransitionPage(const HomeScreen());
        },
        builder: (context, state) {
          _logger.d('Going to home screen');
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.cardInfo.path,
        name: AppRoutes.cardInfo.name,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is CardEntity) {
            return AppTransitions.getTransitionPage(
              CardInfoScreen(card: extra),
            );
          } else {
            return AppTransitions.getTransitionPage(const ErrorScreen());
          }
        },
        builder: (context, state) {
          _logger.d('Going to card info screen');
          final extra = state.extra;
          if (extra is CardEntity) {
            return CardInfoScreen(card: extra);
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
    ],
  );
}
