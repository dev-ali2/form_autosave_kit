import 'dart:convert';

/// A static utility for serializing and deserializing form values safely.
class AutosaveSerializer {
  /// Converts a field values map to a JSON string.
  ///
  /// Only supports `String`, `bool`, `int`, `double`, and `List<String>`.
  /// Unsupported types are silently dropped.
  static String encode(Map<String, dynamic> data) {
    if (data.isEmpty) return '{}';

    final safeData = <String, dynamic>{};
    data.forEach((key, dynamic value) {
      if (value is String ||
          value is bool ||
          value is int ||
          value is double ||
          (value is List &&
              value.every((dynamic element) => element is String))) {
        safeData[key] = value;
      }
    });

    if (safeData.isEmpty) return '{}';
    return jsonEncode(safeData);
  }

  /// Parses a JSON string back into a map.
  ///
  /// Returns an empty map if [jsonString] is null, empty, or malformed.
  static Map<String, dynamic> decode(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } on FormatException {
      return {};
    }
  }
}
