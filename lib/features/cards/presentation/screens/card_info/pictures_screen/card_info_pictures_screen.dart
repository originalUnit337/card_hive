import 'package:card_hive/features/cards/presentation/ui_kit/palette/app_palette.dart';
import 'package:flutter/material.dart';

class CardInfoPicturesScreen extends StatelessWidget {
  const CardInfoPicturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPalette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Card Pictures')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Front',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white70),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera_back_outlined,
                        size: 100,
                        color: currentPalette.primary,
                      ),
                      Text(
                        'Tap to add photo',
                        style: TextStyle(color: currentPalette.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Back',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white70),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera_back_outlined,
                        size: 100,
                        color: currentPalette.primary,
                      ),
                      Text(
                        'Tap to add photo',
                        style: TextStyle(color: currentPalette.primary),
                      ),
                    ],
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
