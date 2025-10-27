import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;
import 'package:path_provider/path_provider.dart';

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

  final ms.MobileScannerController _cameraController =
      ms.MobileScannerController();
  final ValueNotifier<bool> _torchOn = ValueNotifier<bool>(false);

  static const chan = MethodChannel('card_hive/app_settings');
  bool _hasCameraAccess = true;
  bool _isProcessing = false;

  String? _rawSvg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      final status = await chan.invokeMethod('checkPermission', {
        'permission': 'android.permission.CAMERA',
      });
      if (status == 'denied') {
        setState(() => _hasCameraAccess = false);
      } else {
        await _cameraController.start();
        setState(() => _hasCameraAccess = true);
      }
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
    chan
        .invokeMethod('checkPermission', {
          'permission': 'android.permission.CAMERA',
        })
        .then(
          (onValue) => setState(() => _hasCameraAccess = onValue == 'granted'),
        );
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

  Future<void> _onDetect(ms.BarcodeCapture capture) async {
    if (_isProcessing) return;
    final codes = capture.barcodes;
    if (codes.isEmpty) return;
    final codeVal = codes.first.rawValue ?? '';
    if (codeVal.isEmpty) return;

    _isProcessing = true;
    await _cameraController.stop();

    final type = capture.barcodes.first.format;

    Logger().d('CODE: $codeVal, TYPE: $type');

    setState(() {
      final b = Barcode.fromType(barcodeTypeFromFormat(type)!);
      _rawSvg = b.toSvg(codeVal);
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CODE: $codeVal, TYPE: $type')));
    }

    if (widget.store == null && mounted) {
      await context.push(
        AppRoutes.cardInfoEdit.path,
        extra: CardEntity(
          id: 0,
          name: '',
          number: codeVal,
          color: Colors.white,
          rawBarcodeSvg: _rawSvg,
        ),
      );
    } else {
      if (mounted) {
        await context.push(
          AppRoutes.addPremadeCard.path,
          extra: {
            'store': widget.store,
            'card': CardEntity(
              id: 0,
              name: widget.store?.name ?? '',
              number: codeVal,
              color: widget.store?.colorValue ?? Colors.white,
              rawBarcodeSvg: _rawSvg,
              logoPath: widget.store?.logoReference,
            ),
          },
        );
      }
    }
  }

  Future<String> _getSaveDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final saveDir = Directory('${dir.path}/barcodes');
    // ignore: avoid_slow_async_io
    if (await saveDir.exists()) await saveDir.create(recursive: true);
    return saveDir.path;
  }

  Future<File> _saveXFile(XFile xfile) async {
    final bytes = await xfile.readAsBytes();
    final dir = await _getSaveDir();
    final name = 'barcode_${DateTime.now().toIso8601String()}.jpg';
    final file = File('$dir/$name');
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _pickImageAndDecode() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() => _isProcessing = true);
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image picked (decoding not implemented)'),
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Widget _buildSvgPicture(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: SvgPicture.string(_rawSvg!, height: 100),
    );
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
            // ? if (_bytes != null) _buildSvgPicture(context),
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
                            ms.MobileScanner(
                              controller: _cameraController,
                              onDetect: _onDetect,
                            ),
                            Center(
                              child: Container(
                                width: 260,
                                height: 160,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8),
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
                                    onPressed: _cameraController.switchCamera,
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

BarcodeType? barcodeTypeFromFormat(ms.BarcodeFormat fmt) {
  switch (fmt) {
    case ms.BarcodeFormat.itf:
      return BarcodeType.Itf;
    case ms.BarcodeFormat.code128:
      return BarcodeType.Code128;
    case ms.BarcodeFormat.code39:
      return BarcodeType.Code39;
    case ms.BarcodeFormat.code93:
      return BarcodeType.Code93;
    case ms.BarcodeFormat.codabar:
      return BarcodeType.Codabar;
    case ms.BarcodeFormat.dataMatrix:
      return BarcodeType.DataMatrix;
    case ms.BarcodeFormat.ean13:
      return BarcodeType.CodeEAN13;
    case ms.BarcodeFormat.ean8:
      return BarcodeType.CodeEAN8;
    case ms.BarcodeFormat.qrCode:
      return BarcodeType.QrCode;
    case ms.BarcodeFormat.upcA:
      return BarcodeType.CodeUPCA;
    case ms.BarcodeFormat.upcE:
      return BarcodeType.CodeUPCE;
    case ms.BarcodeFormat.pdf417:
      return BarcodeType.PDF417;
    case ms.BarcodeFormat.aztec:
      return BarcodeType.Aztec;
    case ms.BarcodeFormat.unknown:
    case ms.BarcodeFormat.all:
      return null;
  }
}
