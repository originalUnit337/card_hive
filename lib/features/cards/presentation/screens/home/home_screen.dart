import 'package:card_hive/features/cards/presentation/ui_kit/palette/app_palette.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  @override
  Widget build(BuildContext context) {
    final appPalette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: appPalette.appBarbackground,
        title: const Text('Cards'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: DecoratedBox(
              decoration: BoxDecoration(
                color: appPalette.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: appPalette.background),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.6,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),

                child: Material(
                  child: InkWell(
                    onTap: () {
                      //FocusScope.of(context).unfocus();
                      // Future.delayed(Duration(milliseconds: 100)).then(
                      //   (_) =>
                      //       context.mounted
                      //           ? context.push(AppRoutes.cardInfo.path)
                      //           : null,
                      // );
                      context.push(AppRoutes.cardInfo.path);
                    },
                    splashColor: Colors.black54,
                    highlightColor: Colors.black54,
                    splashFactory: InkRipple.splashFactory,
                    child: Ink(
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Center(child: Text(item)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
