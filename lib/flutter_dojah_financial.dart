library flutter_dojah_financial;

import 'package:flutter/material.dart';
import 'package:flutter_dojah_financial/webview_screen.dart';

class DojahFinancial {
  final String appId;
  final String publicKey;
  final String type;
  final Function(dynamic)? onCloseCallback;

  DojahFinancial({
    required this.appId,
    required this.publicKey,
    this.onCloseCallback,
    required this.type,
  });

  Future<void> open(
    BuildContext context, {
    Function(dynamic result)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewScreen(
          appId: appId,
          publicKey: publicKey,
          type: type,
          success: (result) {
            onSuccess!(result);
          },
          error: (error) {
            onError!(error);
          },
        ),
      ),
    );
  }
}
