import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/lib.dart';

import '../../../../models/questions/msq.dart';

class MSQVariationDialog extends StatefulWidget {
  final MSQ msq;

  const MSQVariationDialog({super.key, required this.msq});

  @override
  MSQVariationDialogState createState() => MSQVariationDialogState();
}

class MSQVariationDialogState extends State<MSQVariationDialog> {
  final List<MSQ> _selectedVariations = [];

  void _toggleSelection(MSQ variation) {
    setState(() {
      if (_selectedVariations.contains(variation)) {
        _selectedVariations.remove(variation);
      } else {
        _selectedVariations.add(variation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MSQBloc, MSQState>(
      listener: (context, state) {
        if (state is MSQLoaded) {
          context.read<QuestionsBloc>().add(const LoadQuestions());
          context.pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('MSQ variants saved successfully'), backgroundColor: Colors.green));
        } else if (state is MSQError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red));
        }
      },
      child: ResponsiveScaledBox(
        width: AppConstants.desktopScaleWidth,
        child: PopScope(
          onPopInvokedWithResult: (result, object) {
            context.read<MSQVariationBloc>().add(MSQVariationReset());
          },
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              width: 1300,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Generate MSQ Variations', style: GoogleFonts.jost(fontSize: 56, fontWeight: FontWeight.w400)),
                    Text(
                      'Generate cousin variation of the original question below',
                      style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 20),
                    Text('Original Question', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400)),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.msq.question,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 20),

                    BlocConsumer<MSQVariationBloc, MSQVariationState>(
                      listener: (context, state) {
                        if (state is MSQVariationFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
                        }
                      },
                      builder: (context, state) {
                        if (state is MSQVariationSuccess) {
                          List<Container> checkboxes = [];

                          for (var variation in state.variations) {
                            final isSelected = _selectedVariations.contains(variation);
                            checkboxes.add(
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: isSelected ? Colors.teal : Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSelected ? Colors.teal.withOpacity(0.08) : Colors.white,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => _toggleSelection(variation),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Q. ${variation.question}',
                                          style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 10),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 10,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                          ),
                                          itemCount: variation.options.length,
                                          itemBuilder: (context, index) {
                                            final isAnswer = variation.answerIndices.contains(index);
                                            return Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: isAnswer
                                                    ? Colors.green.shade100
                                                    : Colors.grey.shade200,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  variation.options[index],
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            isSelected ? "Selected" : "Tap to select",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected ? Colors.teal : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Generated Variants (Select to save)',
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 400,
                                child: SingleChildScrollView(child: Column(children: checkboxes)),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                    // Buttons
                    BlocBuilder<MSQVariationBloc, MSQVariationState>(
                      builder: (context, state) {
                        if (state is MSQVariationInitial || state is MSQVariationLoading) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => context.pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.shade200,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                ),
                                child: Text(
                                  'Close',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: (state is! MSQVariationLoading)
                                    ? () {
                                        context.read<MSQVariationBloc>().add(GenerateMSQVariations(widget.msq));
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade300,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                ),
                                icon: (state is MSQVariationInitial)
                                    ? Icon(Icons.account_tree_outlined)
                                    : CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        constraints: BoxConstraints.tightFor(width: 20, height: 20),
                                      ),
                                label: Text(
                                  'Generate Variations',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }

                        if (state is MSQVariationSuccess) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => context.pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.shade200,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                ),
                                child: Text(
                                  'Close',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(width: 16),

                              // Regenerate Variations Button
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<MSQVariationBloc>().add(GenerateMSQVariations(widget.msq));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                ),
                                icon: Icon(Icons.refresh),
                                label: Text(
                                  'Regenerate Variations',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),

                              SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _selectedVariations.isNotEmpty
                                    ? () {
                                        for (var variation in _selectedVariations) {
                                          variation.bankId = widget.msq.bankId;
                                          variation.subject = widget.msq.subject;
                                          variation.difficulty = widget.msq.difficulty;
                                        }
                                        context.read<MSQBloc>().add(SaveBulkMSQs(_selectedVariations));
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade300,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                ),
                                icon: Icon(Icons.save),
                                label: Text(
                                  'Save Variations',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
