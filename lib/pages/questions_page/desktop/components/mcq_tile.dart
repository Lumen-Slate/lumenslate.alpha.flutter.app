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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        spacing: 15,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${mcq.question} (${mcq.runtimeType})',
                style: GoogleFonts.poppins(fontSize: 24, color: Colors.black),
              ),
              Text(
                '${mcq.points} Points',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 1500,
                child: SingleChildScrollView(
                  child: GridView.builder(
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[100],
                        ),
                        child: Text(
                          mcq.options[index],
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[100],
                ),
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
                                ));
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
                              child: MCQVariationDialog(mcq: mcq)),
                        );
                        // _refreshQuestions();
                      },
                      iconSize: 21,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
