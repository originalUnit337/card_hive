import 'package:card_hive/features/cards/presentation/ui_kit/palette/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardInfoEditScreen extends StatefulWidget {
  const CardInfoEditScreen({super.key});

  @override
  State<CardInfoEditScreen> createState() => _CardInfoEditScreenState();
}

class _CardInfoEditScreenState extends State<CardInfoEditScreen> {
  Color selectedChoice = Colors.white;
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final currentPalette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Save')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Form(
                key: GlobalKey<FormState>(),
                child: ColoredBox(
                  color: currentPalette.appBarbackground,
                  child: Column(
                    children: [
                      const Text('Card name'),
                      TextFormField(),
                      const Text('Card Number'),
                      TextFormField(),
                      const Text('Label'),
                      TextFormField(),
                      const Text('Design'),
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child: Container(
                          width: 200,
                          height: 150,
                          decoration: const BoxDecoration(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Add Custom Logo'),
                      ),
                      Padding(
                        padding: const EdgeInsetsGeometry.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Container(
                            height: 70,
                            color: currentPalette.background,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  final isSelected = selectedIndex == index;
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                          ),

                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),

                                            // child: Container(
                                            //   color: Colors.red,
                                            //   width: 40,
                                            //   height: 40,
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
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
