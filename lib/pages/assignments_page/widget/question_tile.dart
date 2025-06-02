import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionTile extends StatelessWidget {
  final String question;
  final List<String>? options;
  final int? points;

  const QuestionTile({
    super.key,
    required this.question,
    this.options,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (points != null)
                  Text(
                    '$points pts',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.orange[400],
                    ),
                  ),
              ],
            ),
            if (options != null && options!.isNotEmpty) ...[
              const SizedBox(height: 6),
              ...options!.asMap().entries.map(
                    (entry) => Text(
                  '${String.fromCharCode(97 + entry.key)}) ${entry.value}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}