import '../storage/autosave_storage.dart';
import '../storage/prefs_storage.dart';

/// Programmatic API to clear, restore, and query the autosave state.
class AutosaveController {
  /// Creates a controller for a specific form.
  ///
  /// If [storage] is not provided, defaults to [PrefsStorage].
  AutosaveController({required this.formId, AutosaveStorage? storage})
    : _storage = storage ?? PrefsStorage();

  /// The unique identifier of the form this controller manages.
  final String formId;

  final AutosaveStorage _storage;

  /// Permanently delete the saved draft for this form.
  /// Call this inside your form's onSubmit after successful server response.
  Future<void> clear() => _storage.clear(formId);

  /// Load saved data and return it. Returns empty map if no draft exists.
  Future<Map<String, dynamic>> restore() => _storage.read(formId);

  /// Returns true if a draft exists and contains at least one field.
  Future<bool> hasSavedData() => _storage.hasData(formId);

  /// Returns the raw saved data map (same as restore but named for clarity).
  Future<Map<String, dynamic>> getSavedData() => _storage.read(formId);
}
