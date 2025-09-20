import 'package:card_hive/features/cards/presentation/ui_kit/palette/app_palette.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CardInfoScreen extends StatefulWidget {
  const CardInfoScreen({super.key});

  @override
  State<CardInfoScreen> createState() => _CardInfoScreenState();
}

class _CardInfoScreenState extends State<CardInfoScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    ScreenBrightness.instance.setApplicationScreenBrightness(1);
  }

  @override
  dispose() {
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
            onPressed: () => context.push(AppRoutes.cardInfoEdit.path),
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
      body: Container(
        decoration: BoxDecoration(color: currentPalette.background),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 7,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // ? logo here if exist
                        child: Center(
                          child: Text(
                            'CopyBook',
                            style: TextStyle(
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
                          '4 810 431 021 569',
                          style: TextStyle(fontSize: 38),
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
                    leading: Icon(Icons.photo_camera),
                    title: Text(
                      'Card Pictures',
                      style: TextStyle(
                        color: currentPalette.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => context.push(AppRoutes.cardInfoPictures.path),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Material(
                  child: InkWell(
                    hoverDuration: Duration(milliseconds: 1000),
                    hoverColor: Colors.yellow,
                    focusColor: Colors.purple,
                    splashColor: Colors.green,
                    highlightColor: Colors.limeAccent,
                    child: ListTile(
                      leading: Icon(Icons.notes),
                      title: Text(
                        'Notes',
                        style: TextStyle(
                          color: currentPalette.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 0)).then((_) {
                        context.mounted
                            ? context.pushNamed(AppRoutes.cardInfoNotes.name)
                            : null;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
