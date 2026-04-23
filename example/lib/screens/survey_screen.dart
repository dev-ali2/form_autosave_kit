import 'package:flutter/material.dart';
import 'package:form_autosave_kit/form_autosave_kit.dart';

/// Survey screen demo
class SurveyScreen extends StatefulWidget {
  /// Survey Form example
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _commentsCtrl = TextEditingController();
  String? _favColor;
  int? _rating;

  final _controller = AutosaveController(formId: 'survey_form');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreDraft();
    });
  }

  Future<void> _restoreDraft() async {
    final data = await _controller.restore();
    if (data.isNotEmpty && mounted) {
      setState(() {
        _nameCtrl.text = data['survey_name'] ?? '';
        _commentsCtrl.text = data['comments'] ?? '';
        final favColor = data['fav_color'];
        final rating = data['rating'];
        _favColor = favColor is String && favColor.isNotEmpty ? favColor : null;
        _rating =
            rating is int
                ? rating
                : rating is String
                ? int.tryParse(rating)
                : null;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Survey submitted!')));

      await _controller.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _checkDraft() async {
    final hasDraft = await _controller.hasSavedData();
    if (!mounted) return;

    if (!hasDraft) {
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text('No Draft'),
              content: Text('There is no saved draft for this form.'),
            ),
      );
      return;
    }

    final data = await _controller.getSavedData();
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Draft Found'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.keys.length,
                itemBuilder: (context, index) {
                  final key = data.keys.elementAt(index);
                  final value = data[key];
                  return ListTile(
                    title: Text(key),
                    subtitle: Text(value.toString()),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survey Form')),
      body: AutosaveForm(
        formId: 'survey_form',
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              AutosaveField(
                fieldId: 'survey_name',
                controller: _nameCtrl,
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  return AutosaveField(
                    fieldId: 'fav_color',
                    child: DropdownButtonFormField<String>(
                      initialValue: _favColor,
                      decoration: const InputDecoration(
                        labelText: 'Favorite Color',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Red', child: Text('Red')),
                        DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                        DropdownMenuItem(value: 'Green', child: Text('Green')),
                      ],
                      onChanged: (val) {
                        setState(() => _favColor = val);
                        AutosaveFormData.maybeOf(
                          context,
                        )?.state.onFieldChanged('fav_color', val);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  return AutosaveField(
                    fieldId: 'rating',
                    child: DropdownButtonFormField<int>(
                      initialValue: _rating,
                      decoration: const InputDecoration(
                        labelText: 'Rating (1-5)',
                      ),
                      items:
                          List.generate(5, (index) => index + 1)
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() => _rating = val);
                        AutosaveFormData.maybeOf(
                          context,
                        )?.state.onFieldChanged('rating', val);
                      },
                      validator:
                          (v) => v == null ? 'Please select a rating' : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AutosaveField(
                fieldId: 'comments',
                controller: _commentsCtrl,
                child: TextFormField(
                  controller: _commentsCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Comments'),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit Survey'),
                  ),
                  OutlinedButton(
                    onPressed: _checkDraft,
                    child: const Text('Check Draft'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _commentsCtrl.dispose();
    super.dispose();
  }
}
