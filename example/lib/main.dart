import 'package:flutter/material.dart';

import 'screens/checkout_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/survey_screen.dart';

void main() => runApp(const AutosaveExampleApp());

/// Example app for form_autosave_kit.
class AutosaveExampleApp extends StatelessWidget {
  /// App root widget.
  const AutosaveExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutosaveKit Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/survey': (context) => const SurveyScreen(),
      },
    );
  }
}

/// Home screen with navigation.
class HomeScreen extends StatelessWidget {
  /// screen widget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AutosaveKit Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
            child: const Text('Checkout Form (Draft Banner & Text Fields)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/registration'),
            child: const Text('Registration Form (Checkboxes & Dropdowns)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/survey'),
            child: const Text('Survey Form (Controller API)'),
          ),
        ],
      ),
    );
  }
}
