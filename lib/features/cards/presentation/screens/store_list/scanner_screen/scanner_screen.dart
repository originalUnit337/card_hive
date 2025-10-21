import 'dart:io';

import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  final StoreEntity? store;
  const ScannerScreen({super.key, this.store});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  static const MethodChannel _platform = MethodChannel(
    'card_hive/app_settings',
  );

  final MobileScannerController _cameraController = MobileScannerController();
  final ValueNotifier<bool> _torchOn = ValueNotifier<bool>(false);

  bool _hasCameraAccess = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      await _cameraController.start();
      setState(() => _hasCameraAccess = true);
    } catch (e) {
      setState(() => _hasCameraAccess = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _torchOn.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasCameraAccess) return;
    if (state == AppLifecycleState.paused) {
      _cameraController.stop();
    } else if (state == AppLifecycleState.resumed) {
      _cameraController.start();
    }
  }

  Future<void> _openAppSettings() async {
    try {
      await _platform.invokeMethod('openAppSettings');
    } on PlatformException {
      // ignore
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final codes = capture.barcodes;
    if (codes.isEmpty) return;
    final codeVal = codes.first.rawValue ?? '';
    if (codeVal.isEmpty) return;

    _isProcessing = true;
    _cameraController.stop();

    Logger().d('CODE: $codeVal');
    if (widget.store == null) {
      context.push(
        AppRoutes.cardInfoEdit.path,
        extra: CardEntity(
          id: 0,
          name: '',
          number: codeVal,
          color: Colors.white,
        ),
      );
    } else {
      context.push(AppRoutes.addPremadeCard.path, extra: widget.store);
    }
  }

  Future<void> _pickImageAndDecode() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() => _isProcessing = true);
    try {
      final bytes = await file.readAsBytes();
      // Декодирование из изображения опущено (см. предыдущие замечания)
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image picked (decoding not implemented)'),
          ),
        );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

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
            // ClipRRect(
            //   borderRadius: BorderRadiusGeometry.circular(15),
            //   child: Container(
            //     height: 500,
            //     width: double.infinity,
            //     color: Colors.black,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         const Text(
            //           'Grant access in\nSettings to continue scanning',
            //           style: TextStyle(color: Colors.white, fontSize: 20),
            //           textAlign: TextAlign.center,
            //         ),
            //         ElevatedButton(
            //           onPressed: () {},
            //           child: const Text('Open Settings'),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 500,
                width: double.infinity,
                color: Colors.black,
                child:
                    _hasCameraAccess
                        ? Stack(
                          children: [
                            MobileScanner(
                              controller: _cameraController,
                              onDetect: _onDetect,
                            ),
                            Center(
                              child: Container(
                                width: 260,
                                height: 160,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.8),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // переключаем фонарь на камере (void) и обновляем локальный флаг
                                      _cameraController.toggleTorch();
                                      _torchOn.value = !_torchOn.value;
                                    },
                                    icon: ValueListenableBuilder<bool>(
                                      valueListenable: _torchOn,
                                      builder: (context, torchOn, child) {
                                        return Icon(
                                          torchOn
                                              ? Icons.flash_on
                                              : Icons.flash_off,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => _cameraController.switchCamera(),
                                    icon: const Icon(
                                      Icons.cameraswitch,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_isProcessing)
                              const Positioned.fill(
                                child: ColoredBox(
                                  color: Colors.black26,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        )
                        : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Grant access in\nSettings to continue scanning',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _openAppSettings,
                                child: const Text('Open Settings'),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Material(
                child: InkWell(
                  onTap: () {
                    if (widget.store == null) {
                      context.push(
                        AppRoutes.cardInfoEdit.path,
                        extra: CardEntity(
                          id: 0,
                          name: '',
                          number: '',
                          color: Colors.white,
                        ),
                      );
                    } else {
                      context.push(
                        AppRoutes.addPremadeCard.path,
                        extra: widget.store,
                      );
                    }
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
