import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

/// Registration Screen demo
class RegistrationScreen extends StatefulWidget {
  /// Registraton Form example
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _country = 'US';
  bool _agreedTerms = false;
  bool _newsletter = false;

  void _onRestored(Map<String, dynamic> data) {
    setState(() {
      _usernameCtrl.text = data['username'] ?? '';
      _passwordCtrl.text = data['password'] ?? '';
      final country = data['country'];
      _country = country is String && country.isNotEmpty ? country : _country;
      _agreedTerms = data['agreed_terms'] == true;
      _newsletter = data['newsletter'] == true;
    });
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreedTerms) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please agree to terms')));
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registered successfully!')));

      await AutosaveController(formId: 'reg_form').clear();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Column(
        children: [
          AutosaveDraftBanner(formId: 'reg_form', onRestore: _onRestored),
          Expanded(
            child: AutosaveForm(
              formId: 'reg_form',
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    AutosaveField(
                      fieldId: 'username',
                      controller: _usernameCtrl,
                      child: TextFormField(
                        controller: _usernameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        validator:
                            (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'password',
                      controller: _passwordCtrl,
                      child: TextFormField(
                        controller: _passwordCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator:
                            (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        return AutosaveField(
                          fieldId: 'country',
                          child: DropdownButtonFormField<String>(
                            initialValue: _country,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'US',
                                child: Text('United States'),
                              ),
                              DropdownMenuItem(
                                value: 'UK',
                                child: Text('United Kingdom'),
                              ),
                              DropdownMenuItem(
                                value: 'CA',
                                child: Text('Canada'),
                              ),
                              DropdownMenuItem(
                                value: 'IN',
                                child: Text('India'),
                              ),
                              DropdownMenuItem(
                                value: 'AU',
                                child: Text('Australia'),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() => _country = val);
                              AutosaveFormData.maybeOf(
                                context,
                              )?.state.onFieldChanged('country', val);
                            },
                            validator: (v) => v == null ? 'Required' : null,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        return AutosaveField(
                          fieldId: 'agreed_terms',
                          child: CheckboxListTile(
                            title: const Text(
                              'I agree to the terms and conditions',
                            ),
                            value: _agreedTerms,
                            onChanged: (val) {
                              setState(() => _agreedTerms = val ?? false);
                              AutosaveFormData.maybeOf(
                                context,
                              )?.state.onFieldChanged('agreed_terms', val);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        return AutosaveField(
                          fieldId: 'newsletter',
                          child: SwitchListTile(
                            title: const Text('Subscribe to newsletter'),
                            value: _newsletter,
                            onChanged: (val) {
                              setState(() => _newsletter = val);
                              AutosaveFormData.maybeOf(
                                context,
                              )?.state.onFieldChanged('newsletter', val);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Register'),
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
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
