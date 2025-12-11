import 'package:flutter/material.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';

class MidtransPaymentSnapPage extends StatefulWidget {
  const MidtransPaymentSnapPage({
    super.key,
    required this.token,
    required this.clientKey,
    required this.redirectUrl,
  });

  final String token;
  final String clientKey;
  final String redirectUrl;

  @override
  State<MidtransPaymentSnapPage> createState() =>
      _MidtransPaymentSnapPageState();
}

class _MidtransPaymentSnapPageState extends State<MidtransPaymentSnapPage> {
  String _status = 'Memulai pembayaran...';
  int _progress = 0;
  late final MidtransSnap _snapView;
  late final MidtransEnvironment _mode;

  @override
  void initState() {
    super.initState();
    final url = widget.redirectUrl.toLowerCase();
    _mode = url.contains('app.midtrans.com')
        ? MidtransEnvironment.production
        : MidtransEnvironment.sandbox;

    _snapView = MidtransSnap(
      mode: _mode,
      token: widget.token,
      midtransClientKey: widget.clientKey,
      onProgress: (p) => setState(() => _progress = p),
      onResponse: (res) => _handleResponse(res),
      onWebResourceError: (err) => _showSnack(err.description),
    );
  }

  void _handleResponse(MidtransResponse? res) {
    if (res == null) return;
    final status = res.transactionStatus;
    setState(() {
      _status = status.isEmpty ? 'Status tidak diketahui' : status;
    });

    if (status == 'settlement' || status == 'capture') {
      _showSnack('Pembayaran berhasil');
      Navigator.of(context).pop(res);
    } else if (status == 'pending') {
      _showSnack('Menunggu pembayaran');
    } else if (status == 'close' || status == 'expire' || status == 'failure') {
      _showSnack('Pembayaran ditutup/gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Midtrans Payment')),
      body: Column(
        children: [
          if (_progress > 0 && _progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.lock, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _status,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _snapView),
        ],
      ),
    );
  }

  void _showSnack(String? message) {
    if (message == null || message.isEmpty) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
