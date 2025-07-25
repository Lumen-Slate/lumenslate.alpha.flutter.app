import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../blocs/mcq_variation_generation/mcq_variation_bloc.dart';
import '../../../../../models/questions/mcq.dart';
import '../../../../../blocs/questions/questions_bloc.dart';
import '../../../../../services/question_api_service.dart';
import '../../../widgets/edit_mcq_dialog.dart';

import '../context_generation_dialog.dart';
import '../mcq_variation_dialog.dart';

class MCQTile extends StatelessWidget {
  final MCQ mcq;
  final bool viewOnly;
  final double _iconSize = 23;

  const MCQTile({super.key, required this.mcq, this.viewOnly = false});

  Future<void> _editQuestion(BuildContext context) async {
    final result = await showDialog<MCQ>(
      context: context,
      builder: (context) => EditMCQDialog(mcq: mcq),
    );

    if (result != null) {
      try {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 12),
                Text('Updating question...', style: GoogleFonts.poppins()),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        await QuestionApiService.updateMCQ(mcq, result);

        // Refresh questions list
        context.read<QuestionsBloc>().add(const LoadQuestions());

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question updated successfully!', style: GoogleFonts.poppins()),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update question: $e', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteQuestion(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Question', style: GoogleFonts.poppins()),
        content: Text(
          'Are you sure you want to delete this question? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 12),
                Text('Deleting question...', style: GoogleFonts.poppins()),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        await QuestionApiService.deleteMCQ(mcq.id);

        // Refresh questions list
        context.read<QuestionsBloc>().add(const LoadQuestions());

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question deleted successfully!', style: GoogleFonts.poppins()),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete question: $e', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: viewOnly ? null : () {},
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black12,
        disabledBackgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(mcq.question, style: GoogleFonts.poppins(fontSize: 24, color: Colors.black)),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('MCQ', style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade800)),
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
                  color: (mcq.answerIndex == index && !viewOnly) ? Colors.greenAccent.shade100 : Colors.grey[100],
                ),
                child: Text(
                  mcq.options[index],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                ),
              );
            },
          ),
          if (!viewOnly)
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
                              questionObject: mcq,
                              type: mcq.runtimeType.toString(),
                              id: mcq.id,
                            ),
                          );
                        },
                        iconSize: _iconSize,
                      ),
                      IconButton(
                        icon: Icon(Icons.account_tree_outlined, color: Colors.blue[700]),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => PopScope(
                              onPopInvokedWithResult: (didPop, result) {
                                if (didPop) {
                                  context.read<MCQVariationBloc>().add(MCQVariationReset());
                                }
                              },
                              child: MCQVariationDialog(mcq: mcq),
                            ),
                          );
                        },
                        iconSize: _iconSize,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, color: Colors.purple),
                        onPressed: () => _editQuestion(context),
                        iconSize: _iconSize,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.red[700]),
                        onPressed: () => _deleteQuestion(context),
                        iconSize: _iconSize,
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
