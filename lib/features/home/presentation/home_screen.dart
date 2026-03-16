import 'package:flutter/material.dart';
import 'package:go/core/widgets/cutom_form_field.dart';
import 'package:go/core/widgets/logo_with_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Placeholder(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoWithText(text: 'Go'),
                  const SizedBox(height: 8),
                  CustomFormField(hint: 'Where do you want to go?'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
