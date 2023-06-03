import 'package:electocracy/app/constants/language.dart';
import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Language.pageNotFound),
      ),
      body: const Center(
        child: Text(
          Language.errorPageNotFound,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
