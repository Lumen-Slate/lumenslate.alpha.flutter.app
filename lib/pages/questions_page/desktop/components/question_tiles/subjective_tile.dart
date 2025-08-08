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
  final bool viewOnly;
  final double _iconSize = 23;

  const SubjectiveTile({super.key, required this.subjective, this.viewOnly = false});

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
                child: Text(subjective.question, style: GoogleFonts.poppins(fontSize: 24, color: Colors.black)),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Subjective', style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade800)),
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
          if (!viewOnly)
            Row(
              children: [
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                  child: Row(
                    spacing: 20,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.lightbulb_outline_rounded, color: Colors.orange[700]),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          foregroundColor: Colors.orange[700],
                          backgroundColor: Colors.orange.shade50,
                          overlayColor: Colors.orange.shade200,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => ContextGenerationDialog(
                              questionObject: subjective,
                              type: subjective.runtimeType.toString(),
                              id: subjective.id,
                            ),
                          );
                        },
                        label: Text(
                          'Story Generation',
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.orange[700]),
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.auto_fix_high_outlined, color: Colors.green[700]),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          foregroundColor: Colors.green[700],
                          backgroundColor: Colors.green.shade50,
                          overlayColor: Colors.green.shade200,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
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
                        label: Text(
                          'Segment',
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.green[700]),
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.edit_outlined, color: Colors.blue[700]),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          foregroundColor: Colors.blue[700],
                          backgroundColor: Colors.blue.shade50,
                          overlayColor: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
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
                                  SnackBar(content: Text('Failed to update question: $e'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          }
                        },
                        label: Text('Edit', style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue[700])),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.red[700]),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          foregroundColor: Colors.red[700],
                          backgroundColor: Colors.red.shade50,
                          overlayColor: Colors.red.shade200,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Subjective Question'),
                              content: Text(
                                'Are you sure you want to delete this subjective question? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancel')),
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
                                  SnackBar(content: Text('Failed to delete question: $e'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          }
                        },
                        label: Text('Delete', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red[700])),
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
