import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/questions/nat.dart';
import 'context_generation_dialog.dart';
import 'question_segmentation_dialog.dart';

class NATTile extends StatelessWidget {
  final NAT nat;

  const NATTile({super.key, required this.nat});

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
              Expanded(
                child: Text(
                  '${nat.question} (${nat.runtimeType})',
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.black),
                ),
              ),
              Text(
                '${nat.points} Points',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
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
                                  question: nat.question,
                                  type: nat.runtimeType.toString(),
                                  id: nat.id,
                                ));
                      },
                      iconSize: 21,
                    ),
                    IconButton(
                      icon: Icon(Icons.auto_fix_high, color: Colors.green[700]),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => QuestionSegmentationDialog(
                            question: nat.question,
                            type: "NAT",
                            id: nat.id,
                          ),
                        );
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