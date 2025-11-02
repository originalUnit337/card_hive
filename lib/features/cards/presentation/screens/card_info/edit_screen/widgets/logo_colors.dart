import 'package:card_hive/core/ui_kit/palette/palette.dart';
import 'package:flutter/material.dart';

class LogoColors extends StatelessWidget {
  const LogoColors({
    required this.currentPalette,
    required ValueNotifier<int?> selectedIndexNotifier,
    required List<Color> colors,
    super.key,
  }) : _selectedIndexNotifier = selectedIndexNotifier,
       _colors = colors;

  final Palette currentPalette;
  final ValueNotifier<int?> _selectedIndexNotifier;
  final List<Color> _colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(10),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: Container(
          height: 70,
          color: currentPalette.background,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ValueListenableBuilder<int?>(
              valueListenable: _selectedIndexNotifier,
              builder: (context, selectedIndex, _) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _selectedIndexNotifier.value = index;
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),

                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _colors[index],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
