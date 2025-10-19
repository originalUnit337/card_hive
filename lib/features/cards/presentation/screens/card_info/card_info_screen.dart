import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_state.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CardInfoScreen extends StatefulWidget {
  final CardEntity card;
  const CardInfoScreen({required this.card, super.key});

  @override
  State<CardInfoScreen> createState() => _CardInfoScreenState();
}

class _CardInfoScreenState extends State<CardInfoScreen> {
  CardEntity? currentCard;
  @override
  void initState() {
    super.initState();
    currentCard = widget.card;
    WakelockPlus.enable();
    ScreenBrightness.instance.setApplicationScreenBrightness(1);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    ScreenBrightness.instance.resetApplicationScreenBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPalette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: currentPalette.appBarbackground,
        actions: [
          TextButton(
            onPressed:
                () => context.push(
                  AppRoutes.cardInfoEdit.path,
                  extra: currentCard,
                ),
            child: Text(
              'Edit',
              style: TextStyle(
                color: currentPalette.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CardInfoBloc, CardInfoState>(
        builder: (context, state) {
          Logger().d('BUILDER WORKS');
          if (state is CardInfoLoaded) {
            currentCard = state.card;
            return DecoratedBox(
              decoration: BoxDecoration(color: currentPalette.background),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 7,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          spacing: 12,
                          children: [
                            Container(
                              height: 170,
                              decoration: BoxDecoration(
                                color: currentCard?.color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // ? logo here if exist
                              child: Center(
                                child: Text(
                                  currentCard?.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Image.asset('assets/bar_codes/test_image.png'),
                            Center(
                              child: Text(
                                currentCard?.number ?? '',
                                style: const TextStyle(fontSize: 38),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Material(
                        child: ListTile(
                          leading: const Icon(Icons.photo_camera),
                          title: Text(
                            'Card Pictures',
                            style: TextStyle(
                              color: currentPalette.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap:
                              () =>
                                  context.push(AppRoutes.cardInfoPictures.path),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Material(
                        child: InkWell(
                          hoverDuration: const Duration(milliseconds: 1000),
                          hoverColor: Colors.yellow,
                          focusColor: Colors.purple,
                          splashColor: Colors.green,
                          highlightColor: Colors.limeAccent,
                          child: ListTile(
                            leading: const Icon(Icons.notes),
                            title: Text(
                              'Notes',
                              style: TextStyle(
                                color: currentPalette.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap:
                              () => context.pushNamed(
                                AppRoutes.cardInfoNotes.name,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
