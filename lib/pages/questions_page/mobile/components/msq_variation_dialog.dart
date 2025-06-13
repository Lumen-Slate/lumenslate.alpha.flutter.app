import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/msq/msq_bloc.dart';
import '../../../../blocs/msq_variation_generation/msq_variation_bloc.dart';
import '../../../../blocs/questions/questions_bloc.dart';
import '../../../../models/questions/msq.dart';

class MSQVariationDialogMobile extends StatefulWidget {
  final MSQ msq;

  const MSQVariationDialogMobile({super.key, required this.msq});

  @override
  State<MSQVariationDialogMobile> createState() => _MSQVariationDialogMobileState();
}

class _MSQVariationDialogMobileState extends State<MSQVariationDialogMobile> {
  final List<MSQ> _selectedVariations = [];

  void _toggleSelection(MSQ variation) {
    setState(() {
      _selectedVariations.contains(variation)
          ? _selectedVariations.remove(variation)
          : _selectedVariations.add(variation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MSQBloc, MSQState>(
      listener: (context, state) {
        if (state is MSQLoaded) {
          // Refresh the main questions list
          context.read<QuestionsBloc>().add(const LoadQuestions());
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('MSQ variants saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MSQError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<MSQVariationBloc, MSQVariationState>(
            listener: (context, state) {
              if (state is MSQVariationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              if (state is MSQVariationSuccess) {
                return Column(
                  children: [
                    const Text('Select MSQ Variations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...state.variations.map((variation) => CheckboxListTile(
                      value: _selectedVariations.contains(variation),
                      onChanged: (_) => _toggleSelection(variation),
                      title: Text(variation.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Options:"),
                          ...variation.options.asMap().entries.map(
                                (entry) => Text(
                              "${String.fromCharCode(97 + entry.key)}) ${entry.value}",
                            ),
                          ),
                          Text(
                            "Answers: ${variation.answerIndices.map((index) => variation.options[index]).join(', ')}",
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 10),
                    BlocBuilder<MSQBloc, MSQState>(
                      builder: (context, state) {
                        if (state is MSQLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ElevatedButton(
                            onPressed: _selectedVariations.isEmpty 
                                ? null 
                                : () => context.read<MSQBloc>().add(SaveBulkMSQs(_selectedVariations)),
                            child: const Text('Save Selected'),
                          );
                        }
                      },
                    ),
                  ],
                );
              } else if (state is MSQVariationInitial) {
                return Column(
                  children: [
                    const Text('Tap to generate variations'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MSQVariationBloc>().add(GenerateMSQVariations(widget.msq));
                      },
                      child: const Text('Generate'),
                    ),
                  ],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
} 