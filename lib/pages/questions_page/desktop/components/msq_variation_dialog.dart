import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/msq/msq_bloc.dart';
import '../../../../blocs/msq_variation_generation/msq_variation_bloc.dart';
import '../../../../models/questions/msq.dart';

class MSQVariationDialog extends StatefulWidget {
  final MSQ msq;

  const MSQVariationDialog({super.key, required this.msq});

  @override
  MSQVariationDialogState createState() => MSQVariationDialogState();
}

class MSQVariationDialogState extends State<MSQVariationDialog> {
  final List<MSQ> _selectedVariations = [];

  void _toggleSelection(MSQ variation) {
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
    return BlocListener<MSQBloc, MSQState>(
      listener: (context, state) {
        if (state is MSQLoaded) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('MSQ variants saved successfully')),
          );
        } else if (state is MSQError) {
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
                  'Generate MSQ Variations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                BlocConsumer<MSQVariationBloc, MSQVariationState>(
                  listener: (context, state) {
                    if (state is MSQVariationFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is MSQVariationSuccess) {
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
                                Text(
                                  "Answers: ${variation.answerIndices.map((index) => variation.options[index]).join(', ')}",
                                ),
                              ],
                            ),
                            value: _selectedVariations.contains(variation),
                            onChanged: (_) => _toggleSelection(variation),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          ...checkboxes,
                          ElevatedButton(
                            onPressed: _selectedVariations.isNotEmpty
                                ? () => context.read<MSQBloc>().add(SaveBulkMSQs(_selectedVariations))
                                : null,
                            child: Text('Add Selected Questions'),
                          ),
                        ],
                      );
                    } else if (state is MSQVariationInitial) {
                      return Column(
                        children: [
                          Text(
                            'Click the button below to generate MSQ variations.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MSQVariationBloc>().add(GenerateMSQVariations(widget.msq));
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
