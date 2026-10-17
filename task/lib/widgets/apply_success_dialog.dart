import 'package:flutter/material.dart';

import '../core/s.dart';

Future<void> showApplySuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Icon(Icons.check_circle, size: 64, color: Colors.green.shade600),
          const SizedBox(height: 16),
          Text(ctx.s.applyDoneTitle,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(ctx.s.applyDoneMsg, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(ctx.s.done),
        ),
      ],
    ),
  );
}
