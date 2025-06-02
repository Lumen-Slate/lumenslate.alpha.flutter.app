import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/mcq/mcq_bloc.dart';
import '../../../../blocs/mcq_variation_generation/mcq_variation_bloc.dart';
import '../../../../models/questions/mcq.dart';


class MCQVariationDialog extends StatefulWidget {
  final MCQ mcq;

  const MCQVariationDialog({super.key, required this.mcq});

  @override
  MCQVariationDialogState createState() => MCQVariationDialogState();
}

class MCQVariationDialogState extends State<MCQVariationDialog> {
  final List<MCQ> _selectedVariations = [];

  void _toggleSelection(MCQ variation) {
    setState(() {
      if (_selectedVariations.contains(variation)) {
        _selectedVariations.remove(variation);
      } else {
        _selectedVariations.add(variation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MCQBloc, MCQState>(
      listener: (context, state) {
        if (state is MCQLoaded) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('MCQ variants saved successfully')),
          );
        } else if (state is MCQError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Generate MCQ Variations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                BlocConsumer<MCQVariationBloc, MCQVariationState>(
                  listener: (context, state) {
                    if (state is MCQVariationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is MCQVariationSuccess) {
                      List<CheckboxListTile> checkboxes = [];

                      for (var variation in state.variations) {
                        checkboxes.add(
                          CheckboxListTile(
                            title: Text(
                              variation.question,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Options:"),
                                ...variation.options.asMap().entries.map((entry) => Text(
                                      "${String.fromCharCode(97 + entry.key)}) ${entry.value}",
                                    )),
                                Text("Answer: ${variation.options[variation.answerIndex]}"),
                              ],
                            ),
                            value: _selectedVariations.contains(variation),
                            onChanged: (_) => _toggleSelection(variation),
                          ),
                        );
                      }

                      return Column(
                        spacing: 30,
                        children: [
                          ...checkboxes,
                          BlocBuilder<MCQBloc, MCQState>(
                            builder: (context, state) {
                              if (state is MCQLoading) {
                                return Center(child: CircularProgressIndicator());
                              } else {
                                return ElevatedButton(
                                  onPressed: _selectedVariations.isNotEmpty
                                      ? () => context.read<MCQBloc>().add(SaveBulkMCQs(_selectedVariations))
                                      : null,
                                  child: Text('Save Selected Questions'),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    } else if (state is MCQVariationInitial) {
                      return Column(
                        children: [
                          Text(
                            'Click the button below to generate MCQ variations.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MCQVariationBloc>().add(GenerateMCQVariations(widget.mcq));
                            },
                            child: Text('Generate Variations'),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
