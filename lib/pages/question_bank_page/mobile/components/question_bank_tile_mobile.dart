import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/question_bank.dart';

class QuestionBankTileMobile extends StatelessWidget {
  final QuestionBank bank;

  const QuestionBankTileMobile({super.key, required this.bank});

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

    List<Color> chipColors = [];
    for (int i = 0; i < bank.tags.length; i++) {
      Color color;
      do {
        color = colors[random.nextInt(colors.length)];
      } while (i > 0 && color == chipColors[i - 1]);
      chipColors.add(color);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        onPressed: () => context.go('/teacher-dashboard/questions?bank=${bank.id}'),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                bank.name,
                style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'Topic: ${bank.topic}',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  for (int i = 0; i < bank.tags.length; i++)
                    Chip(
                      label: Text(bank.tags[i], style: GoogleFonts.poppins(fontSize: 12, color: Colors.white)),
                      backgroundColor: chipColors[i],
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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

