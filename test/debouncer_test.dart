import 'package:flutter_test/flutter_test.dart';
import 'package:form_autosave_kit/src/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('run fires callback after duration', () async {
      var fired = false;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 50));

      debouncer.run(() {
        fired = true;
      });

      expect(fired, isFalse);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(fired, isTrue);
    });

    test('calling run twice cancels the first and fires once', () async {
      var fireCount = 0;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 50));

      debouncer.run(() => fireCount++);
      debouncer.run(() => fireCount++); // Should cancel the first one

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fireCount, equals(1));
    });

    test('cancel prevents the callback from firing', () async {
      var fired = false;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 50));

      debouncer.run(() => fired = true);
      debouncer.cancel();

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fired, isFalse);
    });

    test('dispose prevents pending timer', () async {
      var fired = false;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 50));

      debouncer.run(() => fired = true);
      debouncer.dispose();

      await Future.delayed(const Duration(milliseconds: 100));
      expect(fired, isFalse);
    });
  });
}
