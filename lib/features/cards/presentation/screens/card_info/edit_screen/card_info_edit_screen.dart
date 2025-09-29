import 'dart:io';
import 'dart:ui';

import 'package:card_hive/features/cards/presentation/ui_kit/palette/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CardInfoEditScreen extends StatelessWidget {
  final ValueNotifier<int?> _selectedIndexNotifier = ValueNotifier(0);
  final ValueNotifier<File?> _selectedLogoNotifier = ValueNotifier<File?>(null);

  final ImagePicker _picker = ImagePicker();
  CardInfoEditScreen({super.key});

  //   @override
  //   State<CardInfoEditScreen> createState() => _CardInfoEditScreenState();
  // }

  // class _CardInfoEditScreenState extends State<CardInfoEditScreen> {
  final _colors = [
    Colors.redAccent,
    Colors.red,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    const Color.fromARGB(255, 255, 194, 227),
    Colors.yellow,
    Colors.green,
    Colors.blueGrey,
    Colors.lightBlue,
    Colors.blue,
    Colors.deepPurpleAccent,
  ];

  Future<void> _pickFromCamera(BuildContext context) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) _selectedLogoNotifier.value = File(picked.path);
    } catch (e) {
    } finally {
      if (context.mounted) context.pop(); 
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) _selectedLogoNotifier.value = File(picked.path);
    } catch (e) {
    } finally {
      if (context.mounted) context.pop();
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add custom logo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => _pickFromCamera(context),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => _pickFromGallery(context),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

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
                        child: ValueListenableBuilder(
                          valueListenable: _selectedIndexNotifier,
                          builder: (context, value, child) {
                            return Container(
                              width: 200,
                              height: 150,
                              color: _colors[_selectedIndexNotifier.value ?? 0],
                              child: ValueListenableBuilder(
                                valueListenable: _selectedLogoNotifier,
                                builder: (context, file, _) {
                                  if (file != null) {
                                    return ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Container(
                                            color: Colors.grey.shade300,
                                          ),
                                          BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 6,
                                              sigmaY: 6,
                                            ),
                                            child: Container(
                                              color: Colors.black.withAlpha(0),
                                            ),
                                          ),
                                          Image.file(file, fit: BoxFit.cover),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: Text('No image selected'),
                                    );
                                  }
                                },
                              ),

                            );
                          },
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _selectedLogoNotifier,
                        builder: (context, value, child) {
                          if (_selectedLogoNotifier.value == null) {
                            return TextButton(
                              onPressed: () {
                                _showImageSourceDialog(context);
                              },
                              child: const Text('Add Custom Logo'),
                            );
                          } else {
                            return Row(
                              children: [
                                TextButton(
                                  onPressed: () => _showImageSourceDialog(context),
                                  child: const Text('Change Image'),
                                ),
                                TextButton(
                                  onPressed: () => _selectedLogoNotifier.value = null,
                                  child: const Text('Remove Image'),
                                ),
                              ],
                            );
                          }
                        },
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
                                            _selectedIndexNotifier.value =
                                                index;
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.pop(), child: const Text('Save'))),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => context.pop(), label: const Text('Delete Card'), icon: const Icon(Icons.delete),),)
          ],
        ),
      ),
    );
  }
}
