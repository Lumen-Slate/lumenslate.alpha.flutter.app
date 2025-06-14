import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/questions/nat.dart';
import '../../../../../blocs/questions/questions_bloc.dart';
import '../../../../../services/question_api_service.dart';
import '../../../widgets/edit_nat_dialog.dart';
import '../context_generation_dialog.dart';

class NATTile extends StatelessWidget {
  final NAT nat;
  final bool viewOnly;

  const NATTile({super.key, required this.nat, this.viewOnly = false});


  Future<void> _editQuestion(BuildContext context) async {
    final result = await showDialog<NAT>(
      context: context,
      builder: (context) => EditNATDialog(nat: nat),
    );

    if (result != null) {
      try {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text('Updating question...', style: GoogleFonts.poppins()),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        await QuestionApiService.updateNAT(nat, result);
        
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
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text('Deleting question...', style: GoogleFonts.poppins()),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        await QuestionApiService.deleteNAT(nat.id);
        
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nat.question,
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.black),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'NAT',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${nat.points} Points',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.orange.shade800),
                ),
              ),
            ],
          ),
          if(!viewOnly)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.greenAccent.shade100,
              ),
              child: Text(
                "Answer: ${nat.answer.toString()}",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          if(!viewOnly)
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
                            questionObject: nat,
                            type: nat.runtimeType.toString(),
                            id: nat.id,
                          ),
                        );
                      },
                      iconSize: 21,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue[700]),
                      onPressed: () => _editQuestion(context),
                      iconSize: 21,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[700]),
                      onPressed: () => _deleteQuestion(context),
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