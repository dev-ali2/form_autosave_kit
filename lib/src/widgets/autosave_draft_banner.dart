import 'package:flutter/material.dart';

import '../storage/autosave_storage.dart';
import '../storage/prefs_storage.dart';

/// Optional UI widget that detects a draft on build and shows a banner
/// asking the user to restore or discard changes.
class AutosaveDraftBanner extends StatefulWidget {
  /// Creates the draft banner.
  const AutosaveDraftBanner({
    super.key,
    required this.formId,
    this.storage,
    this.message = 'You have unsaved changes.',
    this.restoreLabel = 'Restore',
    this.discardLabel = 'Discard',
    required this.onRestore,
    this.onDiscard,
    this.backgroundColor,
  });

  /// Unique identifier of the form.
  final String formId;

  /// Custom storage backend. Defaults to [PrefsStorage].
  final AutosaveStorage? storage;

  /// Message displayed in the banner.
  final String message;

  /// The label for the restore button.
  final String restoreLabel;

  /// The label for the discard button.
  final String discardLabel;

  /// Callback to execute when the restore action is triggered.
  final void Function(Map<String, dynamic>) onRestore;

  /// Optional callback to execute when the discard action is triggered.
  final VoidCallback? onDiscard;

  /// Background color of the banner. Defaults to `Colors.amber.shade100`.
  final Color? backgroundColor;

  @override
  State<AutosaveDraftBanner> createState() => _AutosaveDraftBannerState();
}

class _AutosaveDraftBannerState extends State<AutosaveDraftBanner> {
  late final AutosaveStorage _storage;
  bool _hasDraft = false;

  @override
  void initState() {
    super.initState();
    _storage = widget.storage ?? PrefsStorage();
    _checkDraft();
  }

  Future<void> _checkDraft() async {
    final hasDraft = await _storage.hasData(widget.formId);
    if (mounted && hasDraft) {
      setState(() {
        _hasDraft = true;
      });
    }
  }

  Future<void> _handleRestore() async {
    final data = await _storage.read(widget.formId);
    widget.onRestore(data);
    if (mounted) {
      setState(() {
        _hasDraft = false;
      });
    }
  }

  Future<void> _handleDiscard() async {
    await _storage.clear(widget.formId);
    widget.onDiscard?.call();
    if (mounted) {
      setState(() {
        _hasDraft = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasDraft) {
      return const SizedBox.shrink();
    }

    return Material(
      color: widget.backgroundColor ?? Colors.amber.shade100,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 8.0),
              Expanded(child: Text(widget.message)),
              TextButton(
                onPressed: _handleDiscard,
                child: Text(widget.discardLabel),
              ),
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: _handleRestore,
                child: Text(widget.restoreLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
