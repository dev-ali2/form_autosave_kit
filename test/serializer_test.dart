import 'package:flutter_test/flutter_test.dart';
import 'package:form_autosave_kit/src/utils/serializer.dart';

void main() {
  group('AutosaveSerializer', () {
    test('encode/decode round-trip for supported types', () {
      final input = <String, dynamic>{
        'str': 'hello',
        'bool': true,
        'int': 42,
        'double': 3.14,
        'list': ['a', 'b'],
      };
      final jsonStr = AutosaveSerializer.encode(input);
      final output = AutosaveSerializer.decode(jsonStr);
      expect(output, equals(input));
    });

    test('decode(null) returns empty map', () {
      expect(AutosaveSerializer.decode(null), equals({}));
    });

    test('decode empty string returns empty map', () {
      expect(AutosaveSerializer.decode(''), equals({}));
    });

    test('decode malformed json returns empty map without throwing', () {
      expect(AutosaveSerializer.decode('malformed json {{{'), equals({}));
    });

    test('encode({}) returns \'{}\'', () {
      expect(AutosaveSerializer.encode({}), equals('{}'));
    });

    test('encode drops unsupported types silently', () {
      final input = <String, dynamic>{
        'valid': 'ok',
        'date': DateTime.now(), // unsupported
      };
      final jsonStr = AutosaveSerializer.encode(input);
      final output = AutosaveSerializer.decode(jsonStr);
      expect(output, equals({'valid': 'ok'}));
    });
  });
}
