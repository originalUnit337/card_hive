import 'dart:io';
import 'dart:ui';

import 'package:barcode/barcode.dart';
import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_state.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/edit_screen/widgets/logo_colors.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CardInfoEditScreen extends StatefulWidget {
  final CardEntity card;

  const CardInfoEditScreen({required this.card, super.key});

  @override
  State<CardInfoEditScreen> createState() => _CardInfoEditScreenState();
}

class _CardInfoEditScreenState extends State<CardInfoEditScreen> {
  late final ValueNotifier<int?> _selectedIndexNotifier = ValueNotifier(
    _closestColorIndexStatic(widget.card.color),
  );

  late final ValueNotifier<File?> _selectedLogoNotifier;

  late final TextEditingController nameController;
  late final ValueNotifier<String> _nameValue;
  late final TextEditingController numberController;
  late final TextEditingController labelController;

  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.card.name);
    numberController = TextEditingController(text: widget.card.number);
    labelController = TextEditingController(text: widget.card.label ?? '');

    _nameValue = ValueNotifier(widget.card.name);
    if (widget.card.logoPath != null) {
      _selectedLogoNotifier = ValueNotifier<File?>(File(widget.card.logoPath!));
    } else {
      _selectedLogoNotifier = ValueNotifier<File?>(null);
    }
  }

  static int _closestColorIndexStatic(Color target) {
    final colors = [
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
    var bestIndex = 0;
    var bestDist = double.infinity;
    for (var i = 0; i < colors.length; i++) {
      final c = colors[i];
      final dr = c.r - target.r;
      final dg = c.g - target.g;
      final db = c.b - target.b;
      final dist = dr * dr + dg * dg + db * db;
      if (dist < bestDist) {
        bestDist = dist;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  //   @override
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

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    labelController.dispose();
    super.dispose();
  }

  Future<File> _saveToAppDir(File srcFile, String filename) async {
    final appDir = await getApplicationDocumentsDirectory();
    final destPath = '${appDir.path}${Platform.pathSeparator}$filename';
    final dest = File(destPath);
    return srcFile.copy(dest.path);
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) {
        final src = File(picked.path);
        final ext = src.path.contains('.') ? src.path.split('.').last : 'jpg';
        final filename = 'logo_${DateTime.now().microsecondsSinceEpoch}.$ext';
        final saved = await _saveToAppDir(src, filename);
        _selectedLogoNotifier.value = saved;
      }
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
      if (picked != null) {
        final src = File(picked.path);
        final ext = src.path.contains('.') ? src.path.split('.').last : 'jpg';
        final filename = 'logo_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final saved = await _saveToAppDir(src, filename);
        _selectedLogoNotifier.value = saved;
      }
    } finally {
      if (context.mounted) context.pop();
    }
  }

  void _saveCard() {
    var rawBarcodeSvg = widget.card.rawBarcodeSvg;
    rawBarcodeSvg ??= Barcode.code128().toSvg(numberController.text);
    if (_selectedLogoNotifier.value == null && widget.card.logoPath != null) {
      File(widget.card.logoPath!).delete();
    }
    context.read<CardInfoBloc>().add(
      SaveCardEvent(
        widget.card.copyWith(
          name: nameController.value.text,
          number: numberController.text,
          label: labelController.text,
          color: _colors[_selectedIndexNotifier.value ?? 0],
          rawBarcodeSvg: rawBarcodeSvg,
          logoPathSet: true,
          logoPath: _selectedLogoNotifier.value?.path,
        ),
      ),
    );
    final cards = context.read<HomeBloc>().cards;
    final result = cards.indexWhere((el) => el.id == widget.card.id);
    // ! if UPDATE card
    if (result != -1) {
      cards[result] = widget.card.copyWith(
        name: nameController.value.text,
        number: numberController.text,
        label: labelController.text,
        color: _colors[_selectedIndexNotifier.value ?? 0],
        rawBarcodeSvg: rawBarcodeSvg,
        logoPathSet: true,
        logoPath: _selectedLogoNotifier.value?.path,
      );
      context.read<HomeBloc>().add(UpdateCardsEvent(cards));
    }
    // ! if ADD new card
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
    return BlocListener<CardInfoBloc, CardInfoState>(
      listener: (context, state) {
        if (state is CardInfoLoaded) {
          final addedCardOrEditedCard = context.read<CardInfoBloc>().card;
          final cards = context.read<HomeBloc>().cards;
          final result = cards.indexWhere(
            (el) => el.id == addedCardOrEditedCard?.id,
          );
          if (addedCardOrEditedCard != null && result == -1) {
            cards.add(addedCardOrEditedCard);
          }
          context.read<HomeBloc>().add(UpdateCardsEvent(cards));
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          actions: [
            Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveCard();
                    }
                  },
                  child: const Text('Save'),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(15),
          child: SingleChildScrollView(
            child: Column(
              spacing: 12,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Form(
                    key: _formKey,
                    child: ColoredBox(
                      color: currentPalette.appBarbackground,
                      child: Column(
                        children: [
                          const Text('Card name'),
                          TextFormField(
                            controller: nameController,
                            onChanged: (value) {
                              _nameValue.value = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const Text('Card Number'),
                          TextFormField(
                            controller: numberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const Text('Label'),
                          TextFormField(controller: labelController),
                          const Text('Design'),
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            child: ValueListenableBuilder(
                              valueListenable: _selectedIndexNotifier,
                              builder: (context, value, child) {
                                return Container(
                                  width: 200,
                                  height: 150,
                                  color:
                                      _colors[_selectedIndexNotifier.value ??
                                          0],
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
                                                  color: Colors.black.withAlpha(
                                                    0,
                                                  ),
                                                ),
                                              ),
                                              Image.file(
                                                file,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return ValueListenableBuilder(
                                          valueListenable: _nameValue,
                                          builder: (context, value, child) {
                                            return Center(child: Text(value));
                                          },
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
                                return Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _showImageSourceDialog(context);
                                      },
                                      child: const Text('Add Custom Logo'),
                                    ),
                                    LogoColors(
                                      currentPalette: currentPalette,
                                      selectedIndexNotifier:
                                          _selectedIndexNotifier,
                                      colors: _colors,
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed:
                                          () => _showImageSourceDialog(context),
                                      child: const Text('Change Image'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        _selectedLogoNotifier.value = null;
                                      },
                                      child: const Text('Remove Image'),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveCard();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Are you sure you want to delete this card ?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<CardInfoBloc>().add(
                                    RemoveCardEvent(widget.card.id),
                                  );
                                  final cards =
                                      context.read<HomeBloc>().cards
                                        ..removeWhere(
                                          (item) => item.id == widget.card.id,
                                        );
                                  context.read<HomeBloc>().add(
                                    UpdateCardsEvent(cards),
                                  );
                                  context
                                    ..pop()
                                    ..pop()
                                    ..pop();
                                },
                                child: const Text('DELETE CARD'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    label: const Text('Delete Card'),
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
