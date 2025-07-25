import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/lib.dart';

import '../../../../models/questions/mcq.dart';
import '../../../../models/questions/msq.dart';
import '../../../../models/questions/nat.dart';
import '../../../../models/questions/subjective.dart';

class ContextGenerationDialog extends StatefulWidget {
  final dynamic questionObject;
  final String id;
  final String type;

  const ContextGenerationDialog({super.key, required this.questionObject, required this.id, required this.type});

  @override
  ContextGenerationDialogState createState() => ContextGenerationDialogState();
}

class ContextGenerationDialogState extends State<ContextGenerationDialog> {
  final TextEditingController _keywordController = TextEditingController();
  final List<String> _keywords = [];
  final TextEditingController _contextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addKeyword(String keyword) {
    // Normalize keyword: trim, replace inner spaces with hyphens, lowercase
    final normalized = keyword.trim().replaceAll(RegExp(r'\s+'), '-').toLowerCase();
    if (_formKey.currentState?.validate() ?? false) {
      if (normalized.isEmpty) return;
      if (_keywords.length >= 5) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('You can add at most 5 keywords.'), backgroundColor: Colors.red));
        return;
      }
      setState(() {
        _keywords.add(normalized);
        _keywordController.clear();
      });
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  void _generateContext() {
    String questionText = _getQuestionText();
    context.read<ContextGeneratorBloc>().add(GenerateContext(questionText, _keywords));
  }

  String _getQuestionText() {
    switch (widget.questionObject.runtimeType) {
      case MCQ:
        return (widget.questionObject as MCQ).question;
      case MSQ:
        return (widget.questionObject as MSQ).question;
      case NAT:
        return (widget.questionObject as NAT).question;
      case Subjective:
        return (widget.questionObject as Subjective).question;
      default:
        return widget.questionObject.toString();
    }
  }

  void _overrideQuestion() {
    if (_contextController.text.isNotEmpty) {
      context.read<ContextGeneratorBloc>().add(
        OverwriteQuestionWithContext(
          questionId: widget.id,
          questionType: widget.type,
          contextualizedQuestion: _contextController.text,
        ),
      );
    }
  }

  void _saveAsNewQuestion() {
    if (_contextController.text.isNotEmpty) {
      Map<String, dynamic> questionData = _getQuestionDataWithOriginalOptions();
      String bankId = _getBankIdFromOriginalQuestion();

      context.read<ContextGeneratorBloc>().add(
        SaveAsNewQuestionWithContext(
          questionType: widget.type,
          bankId: bankId,
          contextualizedQuestion: _contextController.text,
          questionData: questionData,
        ),
      );
    }
  }

  Map<String, dynamic> _getQuestionDataWithOriginalOptions() {
    switch (widget.questionObject.runtimeType) {
      case MCQ:
        final mcq = widget.questionObject as MCQ;
        return {
          'variableIds': mcq.variableIds,
          'points': mcq.points,
          'options': mcq.options, // Use original options
          'answerIndex': mcq.answerIndex,
        };
      case MSQ:
        final msq = widget.questionObject as MSQ;
        return {
          'variableIds': msq.variableIds,
          'points': msq.points,
          'options': msq.options, // Use original options
          'answerIndices': msq.answerIndices,
        };
      case NAT:
        final nat = widget.questionObject as NAT;
        return {'variableIds': nat.variableIds, 'points': nat.points, 'answer': nat.answer};
      case Subjective:
        final subjective = widget.questionObject as Subjective;
        return {
          'variableIds': subjective.variableIds,
          'points': subjective.points,
          'idealAnswer': subjective.idealAnswer,
          'gradingCriteria': subjective.gradingCriteria,
        };
      default:
        return {'points': 5, 'variableIds': []};
    }
  }

  String _getBankIdFromOriginalQuestion() {
    switch (widget.questionObject.runtimeType) {
      case MCQ:
        return (widget.questionObject as MCQ).bankId;
      case MSQ:
        return (widget.questionObject as MSQ).bankId;
      case NAT:
        return (widget.questionObject as NAT).bankId;
      case Subjective:
        return (widget.questionObject as Subjective).bankId;
      default:
        return ''; // Fallback, though this should not happen
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: PopScope(
        onPopInvokedWithResult: (result, object) {
          context.read<ContextGeneratorBloc>().add(const ContextGeneratorReset());
        },
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 1300,
            // height: 800,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Context Generation', style: GoogleFonts.jost(fontSize: 56, fontWeight: FontWeight.w400)),
                  Text(
                    'Generate a story around your question',
                    style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                  Text('Original Question:', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _getQuestionText(),
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Keyword cannot be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) => _addKeyword(value),
                  ),
                  const SizedBox(height: 20),
                  Text('Keywords (Optional)', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 4),
                  Text(
                    'Keywords can be added to help AI generate more targeted Stories around a question.',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        maxLength: 20,
                        controller: _keywordController,
                        decoration: InputDecoration(
                          labelText: 'Enter keyword',
                          labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _addKeyword(_keywordController.text.trim()),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Keyword cannot be empty';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => _addKeyword(value.trim()),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: _keywords
                        .map((keyword) => Chip(label: Text(keyword), onDeleted: () => _removeKeyword(keyword)))
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                  BlocConsumer<ContextGeneratorBloc, ContextGeneratorState>(
                    listener: (context, state) {
                      if (state is ContextGeneratorSuccess) {
                        _contextController.text = state.response;
                      } else if (state is ContextOverwriteSuccess || state is ContextSaveAsNewSuccess) {
                        String message = state is ContextOverwriteSuccess
                            ? state.message
                            : (state as ContextSaveAsNewSuccess).message;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
                        context.read<QuestionsBloc>().add(const LoadQuestions());
                        context.pop();
                      } else if (state is ContextOverwriteFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Override failed: ${state.error}'), backgroundColor: Colors.red),
                        );
                      }
                      if (state is ContextSaveAsNewFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Save failed: ${state.error}'), backgroundColor: Colors.red),
                        );
                      } else if (state is ContextGeneratorFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.red));
                      }
                    },
                    builder: (context, state) {
                      if (state is ContextGeneratorSuccess) {
                        _contextController.text = state.response;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Generated Question',
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _contextController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Generated context will appear here...',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  
                  BlocBuilder<ContextGeneratorBloc, ContextGeneratorState>(
                    builder: (context, state) {
                      if (state is ContextGeneratorSuccess) {
                        return SizedBox( height: 16 );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      // Close button
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade200,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        ),
                        child: Text('Close', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400)),
                      ),

                      SizedBox(width: 16),

                      BlocBuilder<ContextGeneratorBloc, ContextGeneratorState>(
                        builder: (context, state) {
                          if (state is ContextGeneratorInitial || state is ContextGeneratorLoading) {
                            return ElevatedButton.icon(
                              onPressed: (state is !ContextGeneratorLoading) ? _generateContext : null,
                              icon: (state is ContextGeneratorInitial)
                                  ? Icon(Icons.lightbulb_outline_rounded)
                                  : CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                      constraints: BoxConstraints.tightFor(width: 20, height: 20),
                                    ),
                              label: Text(
                                'Generate Story',
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              ),
                            );
                          }

                          if (state is ContextGeneratorSuccess) {
                            return Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _generateContext,
                                  icon: Icon(Icons.refresh_rounded),
                                  label: Text(
                                    'Re-generate Story',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade400,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                  ),
                                ),
                                SizedBox(width: 16),
                              ],
                            );
                          }

                          return SizedBox.shrink();
                        },
                      ),

                      // Action buttons (shown only when context is generated)
                      BlocBuilder<ContextGeneratorBloc, ContextGeneratorState>(
                        builder: (context, state) {
                          if (state is ContextGeneratorSuccess) {
                            return Row(
                              spacing: 24,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: (state is !ContextOverwriteLoading) ? _overrideQuestion : null,
                                  icon: Icon(Icons.edit),
                                  label: Text(
                                    'Overwrite Question',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: (state is !ContextSaveAsNewLoading) ?  _saveAsNewQuestion : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                  ),
                                  icon: Icon(Icons.add),
                                  label: Text(
                                    'Save as New',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
