import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _addSelectedVariations() {
    // TODO: Implement logic to add selected MCQs to question bank
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_selectedVariations.length} MCQs added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<MCQVariationBloc, MCQVariationState>(
          listener: (context, state) {
            if (state is MCQVariationError) {
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
                  ElevatedButton(
                    onPressed: _selectedVariations.isEmpty ? null : _addSelectedVariations,
                    child: const Text('Add Selected'),
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
    );
  }
}
