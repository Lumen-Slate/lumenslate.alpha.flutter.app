import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../blocs/questions/questions_bloc.dart';
import '../../../../../models/questions/subjective.dart';
import '../../../../../services/question_api_service.dart';
import '../../../widgets/edit_subjective_dialog.dart';

import '../context_generation_dialog.dart';
import '../question_segmentation_dialog.dart';

class SubjectiveTile extends StatelessWidget {
  final Subjective subjective;

  const SubjectiveTile({super.key, required this.subjective});

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
        spacing: 20,
        children: [
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subjective.question,
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.black),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  subjective.runtimeType.toString(),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${subjective.points} Points',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.orange.shade800),
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
                                  questionObject: subjective,
                                  type: subjective.runtimeType.toString(),
                                  id: subjective.id,
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
                            questionObject: subjective,
                            type: "Subjective",
                            id: subjective.id,
                          ),
                        );
                      },
                      iconSize: 21,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue[700]),
                      onPressed: () async {
                        final updatedSubjective = await showDialog<Subjective>(
                          context: context,
                          builder: (context) => EditSubjectiveDialog(subjective: subjective),
                        );
                        
                        if (updatedSubjective != null) {
                          try {
                            await QuestionApiService.updateSubjective(subjective, updatedSubjective);
                            if (context.mounted) {
                              context.read<QuestionsBloc>().add(LoadQuestions());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Subjective question updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update question: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      iconSize: 21,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[700]),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Subjective Question'),
                            content: Text('Are you sure you want to delete this subjective question? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirmed == true) {
                          try {
                            await QuestionApiService.deleteSubjective(subjective.id);
                            if (context.mounted) {
                              context.read<QuestionsBloc>().add(LoadQuestions());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Subjective question deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete question: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
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