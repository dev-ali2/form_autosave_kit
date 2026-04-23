import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

/// Checkout Screen demo
class CheckoutScreen extends StatefulWidget {
  /// Checkout Form example
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _address1Ctrl = TextEditingController();
  final _address2Ctrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  void _onRestored(Map<String, dynamic> data) {
    _nameCtrl.text = data['name'] ?? '';
    _emailCtrl.text = data['email'] ?? '';
    _phoneCtrl.text = data['phone'] ?? '';
    _address1Ctrl.text = data['address1'] ?? '';
    _address2Ctrl.text = data['address2'] ?? '';
    _cityCtrl.text = data['city'] ?? '';
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order placed!')));

      await AutosaveController(formId: 'checkout_form').clear();

      _nameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _address1Ctrl.clear();
      _address2Ctrl.clear();
      _cityCtrl.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          AutosaveDraftBanner(formId: 'checkout_form', onRestore: _onRestored),
          Expanded(
            child: AutosaveForm(
              formId: 'checkout_form',

              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    AutosaveField(
                      fieldId: 'name',
                      controller: _nameCtrl,
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                        validator:
                            (val) =>
                                (val == null || val.isEmpty)
                                    ? 'Required'
                                    : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'email',
                      controller: _emailCtrl,
                      child: TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'phone',
                      controller: _phoneCtrl,
                      child: TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'address1',
                      controller: _address1Ctrl,
                      child: TextFormField(
                        controller: _address1Ctrl,
                        decoration: const InputDecoration(
                          labelText: 'Address Line 1',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'address2',
                      controller: _address2Ctrl,
                      child: TextFormField(
                        controller: _address2Ctrl,
                        decoration: const InputDecoration(
                          labelText: 'Address Line 2 (Optional)',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'city',
                      controller: _cityCtrl,
                      child: TextFormField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _address1Ctrl.dispose();
    _address2Ctrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }
}
