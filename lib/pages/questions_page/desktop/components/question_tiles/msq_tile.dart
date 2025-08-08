import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../blocs/msq_variation_generation/msq_variation_bloc.dart';
import '../../../../../blocs/questions/questions_bloc.dart';
import '../../../../../models/questions/msq.dart';
import '../../../../../services/question_api_service.dart';
import '../../../widgets/edit_msq_dialog.dart';

import '../context_generation_dialog.dart';
import '../msq_variation_dialog.dart';

class MSQTile extends StatelessWidget {
  final MSQ msq;
  final bool viewOnly;
  final double _iconSize = 23;

  const MSQTile({super.key, required this.msq, this.viewOnly = false});

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
                child: Text(
                  msq.question,
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.black),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'MSQ',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${msq.points} Points',
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
            itemCount: msq.options.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: (msq.answerIndices.contains(index) && !viewOnly) ? Colors.greenAccent.shade100 : Colors.grey[100],
                ),
                child: Text(
                  msq.options[index],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                ),
              );
            },
          ),
          if(!viewOnly)
          Row(
            children: [
              Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
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
                            questionObject: msq,
                            type: msq.runtimeType.toString(),
                            id: msq.id,
                          ),
                        );
                      },
                      label: Text(
                        'Story Generation',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.orange[700]),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.account_tree_outlined, color: Colors.blue[700]),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        foregroundColor: Colors.blue[700],
                        backgroundColor: Colors.blue.shade50,
                        overlayColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => PopScope(
                            onPopInvokedWithResult: (didPop, result) {
                              if (didPop) {
                                context.read<MSQVariationBloc>().add(MSQVariationReset());
                              }
                            },
                            child: MSQVariationDialog(msq: msq),
                          ),
                        );
                      },
                      label: Text('Variations', style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue[700])),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.edit_outlined, color: Colors.purple[700]),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        foregroundColor: Colors.purple[700],
                        backgroundColor: Colors.purple.shade50,
                        overlayColor: Colors.purple.shade200,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        final updatedMSQ = await showDialog<MSQ>(
                          context: context,
                          builder: (context) => EditMSQDialog(msq: msq),
                        );
                        
                        if (updatedMSQ != null) {
                          try {
                            await QuestionApiService.updateMSQ(msq, updatedMSQ);
                            if (context.mounted) {
                              context.read<QuestionsBloc>().add(LoadQuestions());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('MSQ updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update MSQ: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      label: Text('Edit', style: GoogleFonts.poppins(fontSize: 16, color: Colors.purple[700])),
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
                            title: Text('Delete MSQ Question'),
                            content: Text('Are you sure you want to delete this MSQ question? This action cannot be undone.'),
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
                            await QuestionApiService.deleteMSQ(msq.id);
                            if (context.mounted) {
                              context.read<QuestionsBloc>().add(LoadQuestions());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('MSQ deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete MSQ: $e'),
                                  backgroundColor: Colors.red,
                                ),
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