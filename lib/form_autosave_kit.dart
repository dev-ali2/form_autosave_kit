/// A Flutter package for automatic form field persistence and restoration.
///
/// This package provides widgets and utilities to automatically save form
/// field values to storage and restore them on app restart.
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:form_autosave_kit/form_autosave_kit.dart';
///
/// class MyForm extends StatefulWidget {
///   @override
///   _MyFormState createState() => _MyFormState();
/// }
///
/// class _MyFormState extends State<MyForm> {
///   final _emailCtrl = TextEditingController();
///
///   @override
///   Widget build(BuildContext context) {
///     return AutosaveForm(
///       formId: 'onboarding_email',
///       onRestored: (data) {
///         _emailCtrl.text = data['email'] ?? '';
///       },
///       child: AutosaveField(
///         fieldId: 'email',
///         controller: _emailCtrl,
///         child: TextFormField(
///           controller: _emailCtrl,
///           decoration: const InputDecoration(labelText: 'Email'),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// ## With Draft Banner
///
/// ```dart
/// class CheckoutScreen extends StatefulWidget {
///   @override
///   State<CheckoutScreen> createState() => _CheckoutScreenState();
/// }
///
/// class _CheckoutScreenState extends State<CheckoutScreen> {
///   final _formKey = GlobalKey<FormState>();
///   final _nameCtrl = TextEditingController();
///   final _emailCtrl = TextEditingController();
///
///   void _onRestored(Map<String, dynamic> data) {
///     _nameCtrl.text = data['name'] ?? '';
///     _emailCtrl.text = data['email'] ?? '';
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Column(
///         children: [
///           AutosaveDraftBanner(
///             formId: 'checkout_form',
///             onRestore: _onRestored,
///           ),
///           Expanded(
///             child: AutosaveForm(
///               formId: 'checkout_form',
///               child: Form(
///                 key: _formKey,
///                 child: ListView(
///                   padding: const EdgeInsets.all(16.0),
///                   children: [
///                     AutosaveField(
///                       fieldId: 'name',
///                       controller: _nameCtrl,
///                       child: TextFormField(
///                         controller: _nameCtrl,
///                         decoration: const InputDecoration(
///                           labelText: 'Full Name',
///                         ),
///                       ),
///                     ),
///                     const SizedBox(height: 16),
///                     AutosaveField(
///                       fieldId: 'email',
///                       controller: _emailCtrl,
///                       child: TextFormField(
///                         controller: _emailCtrl,
///                         decoration:
///                             const InputDecoration(labelText: 'Email'),
///                       ),
///                     ),
///                     const SizedBox(height: 32),
///                     ElevatedButton(
///                       onPressed: () async {
///                         await AutosaveController(
///                           formId: 'checkout_form',
///                         ).clear();
///                       },
///                       child: const Text('Submit'),
///                     ),
///                   ],
///                 ),
///               ),
///             ),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// ## With Controller API
///
/// ```dart
/// class SurveyScreen extends StatefulWidget {
///   @override
///   State<SurveyScreen> createState() => _SurveyScreenState();
/// }
///
/// class _SurveyScreenState extends State<SurveyScreen> {
///   final _nameCtrl = TextEditingController();
///   final _controller = AutosaveController(formId: 'survey_form');
///
///   @override
///   void initState() {
///     super.initState();
///     WidgetsBinding.instance.addPostFrameCallback((_) async {
///       final data = await _controller.restore();
///       if (data.isNotEmpty && mounted) {
///         _nameCtrl.text = data['name'] ?? '';
///       }
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: AutosaveForm(
///         formId: 'survey_form',
///         child: ListView(
///           padding: const EdgeInsets.all(16.0),
///           children: [
///             AutosaveField(
///               fieldId: 'name',
///               controller: _nameCtrl,
///               child: TextFormField(
///                 controller: _nameCtrl,
///                 decoration: const InputDecoration(labelText: 'Name'),
///               ),
///             ),
///             const SizedBox(height: 32),
///             ElevatedButton(
///               onPressed: () async {
///                 await _controller.clear();
///               },
///               child: const Text('Submit'),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
library form_autosave_kit;

export 'src/controller/autosave_controller.dart';
export 'src/storage/autosave_storage.dart';
export 'src/widgets/autosave_draft_banner.dart';
export 'src/widgets/autosave_field.dart';
export 'src/widgets/autosave_form.dart';
