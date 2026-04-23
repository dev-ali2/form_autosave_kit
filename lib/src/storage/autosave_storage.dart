/// Abstract interface for autosave storage backends.
///
/// Implement this interface to provide custom storage backends for saving
/// and restoring form field values.
abstract class AutosaveStorage {
  /// Creates an autosave storage backend.
  AutosaveStorage();

  /// Write all field values for a form. [data] is keyed by fieldId.
  Future<void> write(String formId, Map<String, dynamic> data);

  /// Read all saved field values for a form. Returns empty map if nothing saved.
  Future<Map<String, dynamic>> read(String formId);

  /// Delete all saved data for a form (call after successful submit).
  Future<void> clear(String formId);

  /// Returns true if there is any saved data for this formId.
  Future<bool> hasData(String formId);
}
