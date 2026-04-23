# form_autosave_kit

[![pub package](https://img.shields.io/pub/v/form_autosave_kit.svg)](https://pub.dev/packages/form_autosave_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)

Auto-save & crash-restore for any Flutter form — drop-in, zero boilerplate.

## The Problem

When users are filling out a long form, they may switch apps to copy a code or answer a message. If the OS kills your app in the background to reclaim memory, all of the user's entered data is gone when they return. `form_autosave_kit` elegantly solves this by automatically debouncing and persisting form states, allowing you to instantly restore the form.

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

## API Reference

### `AutosaveForm`

| Parameter      | Type                                       | Default        | Description |
| ---            | ---                                        | ---            | --- |
| `formId`       | `String`                                   | **Required**   | Unique identifier for this form. |
| `child`        | `Widget`                                   | **Required**   | The underlying `Form` widget. |
| `debounceMs`   | `int`                                      | `800`          | Milliseconds to wait before saving to storage. |
| `onRestored`   | `void Function(Map<String, dynamic>)?`     | `null`         | Callback invoked when a draft is successfully read on init. |
| `storage`      | `AutosaveStorage?`                         | `PrefsStorage` | Custom storage backend. |

### `AutosaveField`

| Parameter      | Type                                       | Default        | Description |
| ---            | ---                                        | ---            | --- |
| `fieldId`      | `String`                                   | **Required**   | Unique identifier within its AutosaveForm. |
| `child`        | `Widget`                                   | **Required**   | The underlying input widget. |
| `controller`   | `TextEditingController?`                   | `null`         | For intercepting text fields. |
| `onChanged`    | `void Function(dynamic)?`                  | `null`         | Optional passthrough callback. |

### `AutosaveDraftBanner`

| Parameter         | Type                                       | Default                       | Description |
| ---               | ---                                        | ---                           | --- |
| `formId`          | `String`                                   | **Required**                  | Matches the form ID you want to restore. |
| `message`         | `String`                                   | `'You have unsaved changes.'` | Banner message text. |
| `restoreLabel`    | `String`                                   | `'Restore'`                   | Label of restore button. |
| `discardLabel`    | `String`                                   | `'Discard'`                   | Label of discard button. |
| `onRestore`       | `void Function(Map<String, dynamic>)`      | **Required**                  | Callback to fill controllers here. |
| `onDiscard`       | `VoidCallback?`                            | `null`                        | Optional callback after discard. |
| `backgroundColor` | `Color?`                                   | `Colors.amber.shade100`       | Customizable solid banner color. |
| `storage`         | `AutosaveStorage?`                         | `PrefsStorage`                | Custom storage backend. |

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
