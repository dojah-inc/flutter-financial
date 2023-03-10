library flutter_dojah_kyc;

import 'package:flutter/material.dart';
import 'package:flutter_dojah_financial/webview_screen.dart';

class DojahFinancial {
  final String appId;
  final String publicKey;
  final String type;
  final int? amount;
  final String? referenceId;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? config;
  final Function(dynamic)? onCloseCallback;

  

  DojahFinancial({
    required this.appId,
    required this.publicKey,
    required this.type,
    this.userData,
    this.config,
    this.metaData,
    this.amount,
    this.referenceId,
    this.onCloseCallback,
  });

  Future<void> open(BuildContext context,
      {Function(dynamic result)? onSuccess,
      Function(dynamic close)? onClose,
      Function(dynamic error)? onError}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewScreen(
          appId: appId,
          publicKey: publicKey,
          type: type,
          userData: userData,
          metaData: metaData,
          config: config,
          amount: amount,
          referenceId: referenceId,
          success: (result) {
            onSuccess!(result);
          },

          close: (close) {
              onClose!(close);
          },
          error: (error) {
            onError!(error);
          },
        ),
      ),
    );
  }
}
