import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardInfoEditScreen extends StatelessWidget {
  const CardInfoEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
      ),
      body: Placeholder(),
    );
  }
}
