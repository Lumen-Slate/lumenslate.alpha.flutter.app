import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/context_generation/context_generation_bloc.dart';

class ContextGenerationDialog extends StatefulWidget {
  final String question;
  final String id;
  final String type;

  const ContextGenerationDialog({
    super.key,
    required this.question,
    required this.id,
    required this.type,
  });

  @override
  ContextGenerationDialogState createState() => ContextGenerationDialogState();
}

class ContextGenerationDialogState extends State<ContextGenerationDialog> {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Context Generation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.question,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    labelText: 'Enter keyword',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addKeyword(_keywordController.text),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Keyword cannot be empty';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) => _addKeyword(value),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _keywords.map((keyword) => Chip(
                  label: Text(keyword),
                  onDeleted: () => _removeKeyword(keyword),
                )).toList(),
              ),
              const SizedBox(height: 20),
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
                        SnackBar(content: Text('Question updated successfully')),
                      );
                      // Refresh the question list
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
                    return CircularProgressIndicator();
                  } else {
                    return TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Generated Context',
                        border: OutlineInputBorder(),
                      ),
                      controller: _contextController,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _generateContext,
                    child: Text('Generate Context'),
                  ),
                  ElevatedButton(
                    onPressed: _saveQuestion,
                    child: Text('Save Question'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}