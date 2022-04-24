import 'package:flutter/material.dart';

import '../helpers/i18n/i18n.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final VoidCallback onReloadClick;

  const ReloadScreen({
    required this.error,
    required this.onReloadClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: Text(I18n.strings.reload),
            onPressed: onReloadClick,
          ),
        ],
      ),
    );
  }
}