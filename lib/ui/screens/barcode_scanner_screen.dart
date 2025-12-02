// lib/ui/screens/barcode_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final _ctrl = TextEditingController();
  bool _scanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Development scanner (web). Enter/ paste barcode or mock value and press Use.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Barcode',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _scanning
                        ? null
                        : () {
                      final v = _ctrl.text.trim();
                      if (v.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter a barcode')));
                        return;
                      }
                      // Return the barcode value to caller
                      context.pop(v);
                    },
                    child: const Text('Use'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
