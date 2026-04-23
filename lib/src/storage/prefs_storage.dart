import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/serializer.dart';
import 'autosave_storage.dart';

/// Default [AutosaveStorage] implementation backed by SharedPreferences.
class PrefsStorage implements AutosaveStorage {
  /// Returns the storage key for a specific form.
  String _key(String formId) => 'autosave_kit_$formId';

  @override
  Future<void> write(String formId, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = AutosaveSerializer.encode(data);
      await prefs.setString(_key(formId), jsonStr);
    } catch (e) {
      debugPrint('AutosaveKit: storage error — $e');
    }
  }

  @override
  Future<Map<String, dynamic>> read(String formId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_key(formId));
      return AutosaveSerializer.decode(jsonStr);
    } catch (e) {
      debugPrint('AutosaveKit: storage error — $e');
      return {};
    }
  }

  @override
  Future<void> clear(String formId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key(formId));
    } catch (e) {
      debugPrint('AutosaveKit: storage error — $e');
    }
  }

  @override
  Future<bool> hasData(String formId) async {
    try {
      final data = await read(formId);
      return data.isNotEmpty;
    } catch (e) {
      debugPrint('AutosaveKit: storage error — $e');
      return false;
    }
  }
}
