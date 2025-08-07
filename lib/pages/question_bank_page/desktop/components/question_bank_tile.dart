import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/question_bank.dart';

class QuestionBankTile extends StatelessWidget {
  final QuestionBank bank;

  const QuestionBankTile({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.indigo,
      Colors.pink,
    ];

    // Generate a list of colors ensuring no adjacent chips have the same color
    List<Color> chipColors = [];
    for (int i = 0; i < bank.tags.length; i++) {
      Color color;
      do {
        color = colors[random.nextInt(colors.length)];
      } while (i > 0 && color == chipColors[i - 1]);
      chipColors.add(color);
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => context.go('/teacher-dashboard/questions?bank=${bank.id}'),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            spacing: 14,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bank.name,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Topic: ${bank.topic}',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Wrap(
                spacing: 8,
                children: List.generate(
                  bank.tags.length,
                  (index) => Chip(
                    label: Text(bank.tags[index], style: GoogleFonts.jost(color: Colors.white)),
                    backgroundColor: chipColors[index],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
