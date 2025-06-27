import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChildSignInScreen extends StatefulWidget {
  const ChildSignInScreen({Key? key}) : super(key: key);

  @override
  State<ChildSignInScreen> createState() => _ChildSignInScreenState();
}

class _ChildSignInScreenState extends State<ChildSignInScreen> {
  String? _error;
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _pinCtrl = TextEditingController();

  Future<void> _doSignIn(String childId, String pairingCode) async {
    final resp = await http.post(
      Uri.parse('https://readquest.halfbytegames.net/auth/child-signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'child_id': childId,
        'pairing_code': pairingCode,
      }),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final token = data['access_token'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('child_token', token);
      Navigator.pushReplacementNamed(context, '/childhome');
    } else {
      setState(() => _error = 'Failed to connect. Please try again.');
    }
  }

  Future<void> _scanQr() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _QrScannerPage()),
    );
    if (result == null) return;
    try {
      final payload = jsonDecode(result) as Map<String, dynamic>;
      await _doSignIn(payload['child_id'], payload['pairing_code']);
    } catch (_) {
      setState(() => _error = 'Invalid QR code format');
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Sign-In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1) QR Scan Button
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Parent QR'),
              onPressed: _scanQr,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
            const SizedBox(height: 32),

            // 2) Manual Entry Fields
            TextField(
              controller: _idCtrl,
              decoration: const InputDecoration(
                labelText: 'Child ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinCtrl,
              decoration: const InputDecoration(
                labelText: '6-digit PIN',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final cid = _idCtrl.text.trim();
                final pin = _pinCtrl.text.trim();
                if (cid.isEmpty || pin.length != 6) {
                  setState(() => _error = 'Enter valid ID & 6-digit PIN');
                } else {
                  _doSignIn(cid, pin);
                }
              },
              child: const Text('Connect'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),

            // 3) Error message
            if (_error != null) ...[
              const SizedBox(height: 24),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full-screen QR scanner page
class _QrScannerPage extends StatefulWidget {
  const _QrScannerPage({Key? key}) : super(key: key);
  @override
  State<_QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<_QrScannerPage> {
  late final QRViewController _controller;
  final _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Point camera at QR')),
      body: QRView(
        key: _qrKey,
        onQRViewCreated: (ctrl) {
          _controller = ctrl;
          ctrl.scannedDataStream.listen((scan) {
            _controller.pauseCamera();
            Navigator.of(context).pop(scan.code);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}