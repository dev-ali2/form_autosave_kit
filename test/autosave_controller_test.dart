import 'package:flutter_test/flutter_test.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

class MockStorage implements AutosaveStorage {
  final Map<String, Map<String, dynamic>> _data = {};

  @override
  Future<void> clear(String formId) async {
    _data.remove(formId);
  }

  @override
  Future<bool> hasData(String formId) async {
    final entry = _data[formId];
    return entry != null && entry.isNotEmpty;
  }

  @override
  Future<Map<String, dynamic>> read(String formId) async {
    return _data[formId] ?? {};
  }

  @override
  Future<void> write(String formId, Map<String, dynamic> data) async {
    _data[formId] = data;
  }
}

void main() {
  group('AutosaveController', () {
    late MockStorage storage;
    late AutosaveController controller;

    setUp(() {
      storage = MockStorage();
      controller = AutosaveController(formId: 'test_form', storage: storage);
    });

    test('hasSavedData returns false when storage is empty', () async {
      expect(await controller.hasSavedData(), isFalse);
    });

    test('hasSavedData returns true when storage has data', () async {
      await storage.write('test_form', {'key': 'value'});
      expect(await controller.hasSavedData(), isTrue);
    });

    test('clear removes data from storage', () async {
      await storage.write('test_form', {'key': 'value'});
      expect(await controller.hasSavedData(), isTrue);

      await controller.clear();
      expect(await controller.hasSavedData(), isFalse);
    });

    test('restore returns the stored map', () async {
      await storage.write('test_form', {'key': 'value'});
      final data = await controller.restore();
      expect(data, equals({'key': 'value'}));
    });

    test('getSavedData returns the same result as restore', () async {
      await storage.write('test_form', {'key': 'value'});
      final restoreData = await controller.restore();
      final getData = await controller.getSavedData();
      expect(getData, equals(restoreData));
    });
  });
}
