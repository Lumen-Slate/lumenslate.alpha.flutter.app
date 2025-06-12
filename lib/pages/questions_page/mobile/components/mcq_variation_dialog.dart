import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/mcq/mcq_bloc.dart';
import '../../../../blocs/mcq_variation_generation/mcq_variation_bloc.dart';
import '../../../../models/questions/mcq.dart';

class MCQVariationDialogMobile extends StatefulWidget {
  final MCQ mcq;

  const MCQVariationDialogMobile({super.key, required this.mcq});

  @override
  State<MCQVariationDialogMobile> createState() => _MCQVariationDialogMobileState();
}

class _MCQVariationDialogMobileState extends State<MCQVariationDialogMobile> {
  final List<MCQ> _selectedVariations = [];

  void _toggleSelection(MCQ variation) {
    setState(() {
      _selectedVariations.contains(variation)
          ? _selectedVariations.remove(variation)
          : _selectedVariations.add(variation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MCQBloc, MCQState>(
      listener: (context, state) {
        if (state is MCQLoaded) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('MCQ variants saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MCQError) {
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
          child: BlocConsumer<MCQVariationBloc, MCQVariationState>(
            listener: (context, state) {
              if (state is MCQVariationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              if (state is MCQVariationSuccess) {
                return Column(
                  children: [
                    const Text('Select MCQ Variations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          Text("Answer: ${variation.options[variation.answerIndex]}"),
                        ],
                      ),
                    )),
                    const SizedBox(height: 10),
                    BlocBuilder<MCQBloc, MCQState>(
                      builder: (context, state) {
                        if (state is MCQLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ElevatedButton(
                            onPressed: _selectedVariations.isEmpty 
                                ? null 
                                : () => context.read<MCQBloc>().add(SaveBulkMCQs(_selectedVariations)),
                            child: const Text('Save Selected'),
                          );
                        }
                      },
                    ),
                  ],
                );
              } else if (state is MCQVariationInitial) {
                return Column(
                  children: [
                    const Text('Tap to generate variations'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MCQVariationBloc>().add(GenerateMCQVariations(widget.mcq));
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
