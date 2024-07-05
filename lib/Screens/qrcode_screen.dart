import 'package:barcode_test/Screens/result_screen.dart';
import 'package:barcode_test/Widgets/qr_overlay_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrcodeScreen extends StatefulWidget {
  const QrcodeScreen({super.key});

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen>
    with WidgetsBindingObserver {
  bool isScannedCompleted = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        controller.start();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        controller.stop();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  void _handleBarcode(Barcode barcode) {
    if (!isScannedCompleted) {
      isScannedCompleted = true;
      String code = barcode.rawValue ?? "---";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            url: code,
            onReturn: () {
              setState(() {
                isScannedCompleted = false;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scannez votre code QR!',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Le scan commencera automatiquement',
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 23, right: 23, top: 30, bottom: 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MobileScanner(
                          controller: controller,
                          onDetect: (BarcodeCapture barcodeCapture) {
                            final Barcode barcode =
                                barcodeCapture.barcodes.first;
                            _handleBarcode(barcode);
                          },
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const QRScannerOverlay(
                        overlayColour: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    height: 63,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: const Center(
                        child: Text(
                          'Quitter',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Développé par Marwane Boudouar',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
