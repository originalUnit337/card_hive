import 'package:flutter/material.dart';

/// Common screen which shows if there is any error
class ErrorScreen extends StatelessWidget {
  final String? message;
  const ErrorScreen({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message ?? 'Something went wrong')),
    );
  }
}
