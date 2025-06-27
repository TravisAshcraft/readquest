import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PairingCodeWidget extends StatefulWidget {
  final String secret;
  const PairingCodeWidget({Key? key, this.secret = ''}) : super(key: key);

  @override
  _PairingCodeWidgetState createState() => _PairingCodeWidgetState();
}

class _PairingCodeWidgetState extends State<PairingCodeWidget> {
  late Timer _timer;
  late String _code;
  late int _secondsLeft;

  @override
  void initState() {
    super.initState();
    _updateCode();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final now = DateTime.now();
    final sec = now.second;
    final remain = 60 - sec;
    if (remain == 60) _updateCode(); // boundary hit
    setState(() => _secondsLeft = remain);
  }

  void _updateCode() {
    final epoch = DateTime.now().millisecondsSinceEpoch;
    final codeNum = ((epoch ~/ 1000) % 1000000).toString().padLeft(6, '0');
    setState(() {
      _code = codeNum;
      _secondsLeft = 60 - DateTime.now().second;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImageView( // <-- Use QrImageView instead of QrImage
          data: _code,
          version: QrVersions.auto,
          size: 100.0,
        ),
        const SizedBox(height: 4),
        Text(_code, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Expires in $_secondsLeft s', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
