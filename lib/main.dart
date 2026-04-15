import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Pages/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PinCodePage(),
    );
  }
}

/// PIN PAGE
class PinCodePage extends StatefulWidget {
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _showError(String message) {
    pinController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToHome() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'jkjk')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Authentication",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Secure Your Wallet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 30),

              /// PIN INPUT
              Pinput(
                length: 4,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                hapticFeedbackType: HapticFeedbackType.heavyImpact,
                separatorBuilder: (_) => const SizedBox(width: 8),
                onCompleted: (value) async {
                  final storage = StorageService();
                  final storedPin = await storage.readData('pin');
                  // example : if the user close the app before setting the pin

                  if (!mounted) return;

                  /// FIRST TIME SET PIN
                  if (storedPin == null) {
                    await storage.writeData('pin', value);
                    _navigateToHome();
                    return;
                  }

                  /// CHECK PIN
                  if (storedPin == value) {
                    _navigateToHome();
                  } else {
                    _showError("Invalid PIN");
                  }
                },
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SECURE STORAGE SERVICE
class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
