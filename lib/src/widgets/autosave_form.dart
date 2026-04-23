import 'package:flutter/widgets.dart';

import '../storage/autosave_storage.dart';
import '../storage/prefs_storage.dart';
import '../utils/debouncer.dart';

/// InheritedWidget that provides access to the [AutosaveFormState].
class AutosaveFormData extends InheritedWidget {
  /// Creates the inherited widget.
  const AutosaveFormData({
    super.key,
    required this.state,
    required super.child,
  });

  /// The state of the [AutosaveForm].
  final AutosaveFormState state;

  /// Look up the nearest [AutosaveFormData] in the ancestor tree.
  static AutosaveFormData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AutosaveFormData>();

  @override
  bool updateShouldNotify(AutosaveFormData old) => old.state != state;
}

/// The top-level widget that manages auto-saving form fields.
class AutosaveForm extends StatefulWidget {
  /// Creates an AutosaveForm.
  const AutosaveForm({
    super.key,
    required this.formId,
    required this.child,
    this.debounceMs = 800,
    this.onRestored,
    this.storage,
  });

  /// Unique identifier for this form.
  final String formId;

  /// The widget below this widget in the tree, typically a [Form].
  final Widget child;

  /// Milliseconds to wait before saving to storage.
  final int debounceMs;

  /// Optional callback invoked when a draft is successfully read on init.
  final void Function(Map<String, dynamic>)? onRestored;

  /// Optional custom storage backend. Defaults to [PrefsStorage].
  final AutosaveStorage? storage;

  @override
  State<AutosaveForm> createState() => AutosaveFormState();
}

/// State for [AutosaveForm].
class AutosaveFormState extends State<AutosaveForm> {
  late final AutosaveStorage _storage;
  late final Debouncer _debouncer;
  final Map<String, dynamic> _fieldValues = {};

  @override
  void initState() {
    super.initState();
    _storage = widget.storage ?? PrefsStorage();
    _debouncer = Debouncer(duration: Duration(milliseconds: widget.debounceMs));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final savedData = await _storage.read(widget.formId);
      if (savedData.isNotEmpty) {
        widget.onRestored?.call(savedData);
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  /// Shorthand to trigger an update.
  void onFieldChanged(String fieldId, dynamic value) {
    updateField(fieldId, value);
  }

  /// Registers a field's initial value without triggering a save.
  void registerField(String fieldId, dynamic value) {
    _fieldValues[fieldId] = value;
  }

  /// Updates a field's value and triggers a debounced save.
  void updateField(String fieldId, dynamic value) {
    _fieldValues[fieldId] = value;
    _debouncer.run(_persist);
  }

  Future<void> _persist() async {
    await _storage.write(widget.formId, _fieldValues);
  }

  /// Clears the saved draft for this form permanently.
  Future<void> clearDraft() => _storage.clear(widget.formId);

  /// Returns the current saved data map.
  Future<Map<String, dynamic>> getSavedData() => _storage.read(widget.formId);

  @override
  Widget build(BuildContext context) {
    return AutosaveFormData(state: this, child: widget.child);
  }
}
