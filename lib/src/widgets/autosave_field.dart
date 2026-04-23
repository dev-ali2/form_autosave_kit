import 'package:flutter/widgets.dart';

import 'autosave_form.dart';

/// Wraps a form field widget to automatically report changes to [AutosaveForm].
class AutosaveField extends StatefulWidget {
  /// Creates an AutosaveField.
  const AutosaveField({
    super.key,
    required this.fieldId,
    required this.child,
    this.controller,
    this.onChanged,
  });

  /// Unique identifier within its [AutosaveForm].
  final String fieldId;

  /// The actual field widget.
  final Widget child;

  /// Optional text controller, used to record changes automatically.
  final TextEditingController? controller;

  /// Callback to wire the child field's onChanged event through this widget.
  final void Function(dynamic)? onChanged;

  @override
  State<AutosaveField> createState() => _AutosaveFieldState();
}

class _AutosaveFieldState extends State<AutosaveField> {
  late AutosaveFormState _formState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final formData = AutosaveFormData.maybeOf(context);
    if (formData == null) {
      throw FlutterError(
        "AutosaveField (fieldId: '${widget.fieldId}') must be a descendant of AutosaveForm.",
      );
    }
    _formState = formData.state;
    _formState.registerField(widget.fieldId, widget.controller?.text ?? '');
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(AutosaveField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller != null) {
      _formState.onFieldChanged(widget.fieldId, widget.controller!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onChanged != null) {
      // In a real generic wrapper, we'd wrap child to intercept onChanged.
      // Since the specification avoids introspection and cloning for generic child types,
      // the developer will manually call `AutosaveFormData.maybeOf(context)?.state.onFieldChanged`
      // or pass their own bound callback.
    }
    return widget.child;
  }
}
