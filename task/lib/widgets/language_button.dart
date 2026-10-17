import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isHindi = context.watch<LanguageProvider>().isHindi;
    return TextButton(
      onPressed: () => context.read<LanguageProvider>().toggle(),
      child: Text(isHindi ? 'EN' : 'हिं',
          style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
