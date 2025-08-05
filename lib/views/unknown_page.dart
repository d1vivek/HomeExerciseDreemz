import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  final String? error;

  const UnknownPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(error ?? "Unknown Page")));
  }
}
