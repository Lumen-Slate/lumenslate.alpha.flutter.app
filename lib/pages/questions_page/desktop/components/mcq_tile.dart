import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../blocs/mcq_variation_generation/mcq_variation_bloc.dart';
import '../../../../models/questions/mcq.dart';
import 'context_generation_dialog.dart';
import 'mcq_variation_dialog.dart';

class MCQTile extends StatelessWidget {
  final MCQ mcq;

  const MCQTile({super.key, required this.mcq});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black12,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: Text(mcq.question, style: GoogleFonts.poppins(fontSize: 24, color: Colors.black)),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  mcq.runtimeType.toString(),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${mcq.points} Points',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.orange.shade800),
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 12,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: mcq.options.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: (mcq.answerIndex == index) ? Colors.greenAccent.shade100 : Colors.grey[100],
                ),
                child: Text(
                  mcq.options[index],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                ),
              );
            },
          ),
          Row(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey[100]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.lightbulb_outline_rounded, color: Colors.orange[700]),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => ContextGenerationDialog(
                            question: mcq.question,
                            type: mcq.runtimeType.toString(),
                            id: mcq.id,
                          ),
                        );
                        // _refreshQuestions();
                      },
                      iconSize: 21,
                    ),
                    IconButton(
                      icon: Icon(Icons.account_tree, color: Colors.blue[700]),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => PopScope(
                            onPopInvokedWithResult: (didPop, result) {
                              if (didPop) {
                                context.read<MCQVariationBloc>().add(MCQVariationReset());
                                // _refreshQuestions();
                              }
                            },
                            child: MCQVariationDialog(mcq: mcq),
                          ),
                        );
                        // _refreshQuestions();
                      },
                      iconSize: 21,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}