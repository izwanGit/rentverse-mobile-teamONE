import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/auth/domain/usecase/send_otp_usecase.dart';
import 'package:rentverse/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:rentverse/core/resources/data_state.dart';
import 'package:dio/dio.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String target;
  final String channel; // 'EMAIL' or 'WHATSAPP'

  const OtpVerificationScreen({
    super.key,
    required this.target,
    required this.channel,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isSending = false;

  Future<void> _sendOtp() async {
    setState(() => _isSending = true);
    final usecase = sl<SendOtpUseCase>();
    final params = SendOtpParams(
      target: widget.target,
      channel: widget.channel,
    );
    try {
      final result = await usecase.call(param: params);
      if (result is DataSuccess<bool>) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent successfully')));
      } else if (result is DataFailed) {
        // Try to extract server message from DioException
        String msg = 'Failed to send OTP';
        final err = result.error;
        if (err is DioException) {
          final resp = err.response;
          if (resp != null && resp.data != null) {
            final d = resp.data;
            if (d is Map && d['message'] != null)
              msg = d['message'].toString();
            else
              msg = resp.statusMessage ?? err.message ?? msg;
          } else {
            msg = err.message ?? msg;
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send OTP: $e')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _verifyOtp() async {
    final code = _controller.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP must be 6 digits')));
      return;
    }

    setState(() => _isLoading = true);
    final usecase = sl<VerifyOtpUseCase>();
    final params = VerifyOtpParams(
      target: widget.target,
      channel: widget.channel,
      code: code,
    );
    try {
      final result = await usecase.call(param: params);
      if (result is DataSuccess<bool>) {
        final updated = result.data == true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updated ? 'Verification successful' : 'OTP verified'),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (result is DataFailed) {
        String msg = 'Verification failed';
        final err = result.error;
        if (err is DioException) {
          final resp = err.response;
          if (resp != null && resp.data != null) {
            final d = resp.data;
            if (d is Map && d['message'] != null)
              msg = d['message'].toString();
            else
              msg = resp.statusMessage ?? err.message ?? msg;
          } else {
            msg = err.message ?? msg;
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Verification error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Send OTP immediately when opening
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: appPrimaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                widget.channel.toUpperCase() == 'EMAIL'
                    ? 'Email Verification'
                    : 'Phone Verification',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We have sent a 6 digit code to ${widget.target}.',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(
                  hintText: 'Enter 6-digit code',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(letterSpacing: 8, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Verify'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _isSending ? null : _sendOtp,
                    child: _isSending
                        ? const Text('Resending...')
                        : const Text('Resend Code'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
