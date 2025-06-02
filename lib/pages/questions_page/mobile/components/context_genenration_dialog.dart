import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/context_generation/context_generation_bloc.dart';

class ContextGenerationDialogMobile extends StatefulWidget {
  final String question;
  final String id;
  final String type;

  const ContextGenerationDialogMobile({
    super.key,
    required this.question,
    required this.id,
    required this.type,
  });

  @override
  State<ContextGenerationDialogMobile> createState() => _ContextGenerationDialogMobileState();
}

class _ContextGenerationDialogMobileState extends State<ContextGenerationDialogMobile> {
  final TextEditingController _keywordController = TextEditingController();
  final List<String> _keywords = [];
  String _generatedContext = '';
  final TextEditingController _contextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addKeyword(String keyword) {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _keywords.add(keyword);
        _keywordController.clear();
      });
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  void _generateContext() {
    context.read<ContextGeneratorBloc>().add(GenerateContext(widget.question, _keywords));
  }

  void _saveQuestion() {
    context.read<ContextGeneratorBloc>().add(SaveQuestion(widget.id, widget.type, _contextController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Context Generation', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(widget.question),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _keywordController,
                decoration: InputDecoration(
                  labelText: 'Enter keyword',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addKeyword(_keywordController.text),
                  ),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Keyword cannot be empty' : null,
                onFieldSubmitted: (value) => _addKeyword(value),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _keywords
                  .map((k) => Chip(label: Text(k), onDeleted: () => _removeKeyword(k)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            BlocConsumer<ContextGeneratorBloc, ContextGeneratorState>(
              listener: (context, state) {
                if (state is ContextGeneratorSuccess) {
                  setState(() {
                    _generatedContext = state.response;
                    _contextController.text = _generatedContext;
                  });
                  if (state.response == 'Question updated successfully') {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Question updated successfully')),
                    );
                    context.go('/teacher-dashboard/questions');
                  }
                } else if (state is ContextGeneratorFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is ContextGeneratorLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  );
                }
                return TextField(
                  maxLines: 6,
                  controller: _contextController,
                  decoration: const InputDecoration(
                    labelText: 'Generated Context',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateContext,
                    child: const Text('Generate'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveQuestion,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
