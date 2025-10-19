import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCustomCardScreen extends StatelessWidget {
  const AddCustomCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPalette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(15),
        child: Column(
          spacing: 15,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(15),
              child: Container(
                height: 500,
                width: double.infinity,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Grant access in\nSettings to continue scanning',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Material(
                child: InkWell(
                  onTap: () {
                    context.push(AppRoutes.cardInfoEdit.path, extra: CardEntity(id: 0, name: '', number: '', color: Colors.white));
                  },
                  child: ListTile(
                    title: Text(
                      'Enter manually',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: currentPalette.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text(
                      'Import screenshot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: currentPalette.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
