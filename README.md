# form_autosave_kit

[![pub package](https://img.shields.io/pub/v/form_autosave_kit.svg)](https://pub.dev/packages/form_autosave_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)

Auto-save & crash-restore for any Flutter form — drop-in, zero boilerplate.

## The Problem

When users are filling out a long form, they may switch apps to copy a code or answer a message. If the OS kills your app in the background to reclaim memory, all of the user's entered data is gone when they return. `form_autosave_kit` elegantly solves this by automatically debouncing and persisting form states, allowing you to instantly restore the form.

## Visual

<img width="320" height="693" alt="ezgif-666f73ad94bdd545" src="https://github.com/user-attachments/assets/06061b83-7756-4594-902c-0d75714dc684" />

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  form_autosave_kit: ^0.0.1
```

Run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AutosaveForm(
      formId: 'onboarding_email',
      onRestored: (data) {
        _emailCtrl.text = data['email'] ?? '';
      },
      child: AutosaveField(
        fieldId: 'email',
        controller: _emailCtrl,
        child: TextFormField(
          controller: _emailCtrl,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
      ),
    );
  }
}
```

## Full Examples

### Checkout Form (with Draft Banner)

```dart
import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

class CheckoutScreen extends StatefulWidget {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed!')),
      );
      await AutosaveController(formId: 'checkout_form').clear();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          AutosaveDraftBanner(
            formId: 'checkout_form',
            onRestore: _onRestored,
          ),
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
                        validator: (val) =>
                            (val == null || val.isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'email',
                      controller: _emailCtrl,
                      child: TextFormField(
                        controller: _emailCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutosaveField(
                      fieldId: 'phone',
                      controller: _phoneCtrl,
                      child: TextFormField(
                        controller: _phoneCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Phone'),
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
                        decoration:
                            const InputDecoration(labelText: 'City'),
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
```

### Registration Form (with Dropdowns & Checkboxes)

```dart
import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

class RegistrationScreen extends StatefulWidget {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to terms')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully!')),
      );
      await AutosaveController(formId: 'reg_form').clear();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Column(
        children: [
          AutosaveDraftBanner(
            formId: 'reg_form',
            onRestore: _onRestored,
          ),
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
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
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
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
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
                              AutosaveFormData.maybeOf(context)
                                  ?.state
                                  .onFieldChanged('country', val);
                            },
                            validator: (v) =>
                                v == null ? 'Required' : null,
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
                              setState(
                                () => _agreedTerms = val ?? false,
                              );
                              AutosaveFormData.maybeOf(context)
                                  ?.state
                                  .onFieldChanged('agreed_terms', val);
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
                              AutosaveFormData.maybeOf(context)
                                  ?.state
                                  .onFieldChanged('newsletter', val);
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
```

### Survey Form (using AutosaveController API)

```dart
import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _commentsCtrl = TextEditingController();
  String? _favColor;
  int? _rating;

  final _controller = AutosaveController(formId: 'survey_form');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreDraft();
    });
  }

  Future<void> _restoreDraft() async {
    final data = await _controller.restore();
    if (data.isNotEmpty && mounted) {
      setState(() {
        _nameCtrl.text = data['survey_name'] ?? '';
        _commentsCtrl.text = data['comments'] ?? '';
        final favColor = data['fav_color'];
        final rating = data['rating'];
        _favColor =
            favColor is String && favColor.isNotEmpty ? favColor : null;
        _rating = rating is int
            ? rating
            : rating is String
            ? int.tryParse(rating)
            : null;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey submitted!')),
      );
      await _controller.clear();
      if (mounted) Navigator.pop(context);
    }
  }

  void _checkDraft() async {
    final hasDraft = await _controller.hasSavedData();
    if (!mounted) return;

    if (!hasDraft) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('No Draft'),
          content: Text('There is no saved draft for this form.'),
        ),
      );
      return;
    }

    final data = await _controller.getSavedData();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Draft Found'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.keys.length,
            itemBuilder: (context, index) {
              final key = data.keys.elementAt(index);
              final value = data[key];
              return ListTile(
                title: Text(key),
                subtitle: Text(value.toString()),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survey Form')),
      body: AutosaveForm(
        formId: 'survey_form',
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              AutosaveField(
                fieldId: 'survey_name',
                controller: _nameCtrl,
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Name'),
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  return AutosaveField(
                    fieldId: 'fav_color',
                    child: DropdownButtonFormField<String>(
                      initialValue: _favColor,
                      decoration: const InputDecoration(
                        labelText: 'Favorite Color',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Red',
                          child: Text('Red'),
                        ),
                        DropdownMenuItem(
                          value: 'Blue',
                          child: Text('Blue'),
                        ),
                        DropdownMenuItem(
                          value: 'Green',
                          child: Text('Green'),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _favColor = val);
                        AutosaveFormData.maybeOf(context)
                            ?.state
                            .onFieldChanged('fav_color', val);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  return AutosaveField(
                    fieldId: 'rating',
                    child: DropdownButtonFormField<int>(
                      initialValue: _rating,
                      decoration: const InputDecoration(
                        labelText: 'Rating (1-5)',
                      ),
                      items: List.generate(5, (index) => index + 1)
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => _rating = val);
                        AutosaveFormData.maybeOf(context)
                            ?.state
                            .onFieldChanged('rating', val);
                      },
                      validator: (v) =>
                          v == null ? 'Please select a rating' : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AutosaveField(
                fieldId: 'comments',
                controller: _commentsCtrl,
                child: TextFormField(
                  controller: _commentsCtrl,
                  maxLines: 4,
                  decoration:
                      const InputDecoration(labelText: 'Comments'),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit Survey'),
                  ),
                  OutlinedButton(
                    onPressed: _checkDraft,
                    child: const Text('Check Draft'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _commentsCtrl.dispose();
    super.dispose();
  }
}
```

## API Reference

### `AutosaveForm`

| Parameter    | Type                                   | Default        | Description                                                 |
| ------------ | -------------------------------------- | -------------- | ----------------------------------------------------------- |
| `formId`     | `String`                               | **Required**   | Unique identifier for this form.                            |
| `child`      | `Widget`                               | **Required**   | The underlying `Form` widget.                               |
| `debounceMs` | `int`                                  | `800`          | Milliseconds to wait before saving to storage.              |
| `onRestored` | `void Function(Map<String, dynamic>)?` | `null`         | Callback invoked when a draft is successfully read on init. |
| `storage`    | `AutosaveStorage?`                     | `PrefsStorage` | Custom storage backend.                                     |

### `AutosaveField`

| Parameter    | Type                      | Default      | Description                                |
| ------------ | ------------------------- | ------------ | ------------------------------------------ |
| `fieldId`    | `String`                  | **Required** | Unique identifier within its AutosaveForm. |
| `child`      | `Widget`                  | **Required** | The underlying input widget.               |
| `controller` | `TextEditingController?`  | `null`       | For intercepting text fields.              |
| `onChanged`  | `void Function(dynamic)?` | `null`       | Optional passthrough callback.             |

### `AutosaveDraftBanner`

| Parameter         | Type                                  | Default                       | Description                              |
| ----------------- | ------------------------------------- | ----------------------------- | ---------------------------------------- |
| `formId`          | `String`                              | **Required**                  | Matches the form ID you want to restore. |
| `message`         | `String`                              | `'You have unsaved changes.'` | Banner message text.                     |
| `restoreLabel`    | `String`                              | `'Restore'`                   | Label of restore button.                 |
| `discardLabel`    | `String`                              | `'Discard'`                   | Label of discard button.                 |
| `onRestore`       | `void Function(Map<String, dynamic>)` | **Required**                  | Callback to fill controllers here.       |
| `onDiscard`       | `VoidCallback?`                       | `null`                        | Optional callback after discard.         |
| `backgroundColor` | `Color?`                              | `Colors.amber.shade100`       | Customizable solid banner color.         |
| `storage`         | `AutosaveStorage?`                    | `PrefsStorage`                | Custom storage backend.                  |

### `AutosaveController`

Programmatic API for manual controls.

- `Future<void> clear()`: Permanently delete the saved draft for this form.
- `Future<Map<String, dynamic>> restore()`: Load saved data and return it.
- `Future<bool> hasSavedData()`: Returns true if a draft exists and contains at least one field.
- `Future<Map<String, dynamic>> getSavedData()`: Same as restore, aliased for clarity.

### `AutosaveStorage`

Abstract interface to implement custom storage backends (e.g. Hive, ObjectBox, SQLite).

## Data Types Supported

- `String`, `bool`, `int`, `double`, `List<String>`
- Other unsupported types are silently dropped.

## Architecture

**Save Path:**

```
TextFormField text changes -> controller updates -> AutosaveField intercepts ->
AutosaveForm triggers Debouncer -> Writes JSON via Storage Backend
```

**Restore Path:**

```
App opens -> AutosaveForm mounts -> Checks Storage Backend for "formId" key
-> Calls onRestored(Map) -> Developer updates controllers
```

## Roadmap

For `v2`, the following features are planned:

- TTL / draft expiry
- Per-user namespacing (`userId` parameter)
- Custom storage backends out-of-the-box
- `excludeFields` / `@AutosaveExclude` annotation
- `AppLifecycleListener` save-on-background hook

## Contributing

Pull requests are welcome. Please open an issue first to discuss what you would like to change.

## License

MIT
