import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/lib.dart';
import '../../../../blocs/nat/nat_bloc.dart';
import '../../../../blocs/subjective/subjective_bloc.dart';
import '../../../../serializers/rag_agent_serializers/rag_generated_questions_serializer.dart';
import '../../../../models/questions/mcq.dart';
import '../../../../models/questions/msq.dart';
import '../../../../models/questions/nat.dart';
import '../../../../models/questions/subjective.dart';

class GeneratedQuestionsChoiceDialog extends StatefulWidget {
  final RagGeneratedQuestionsSerializer serializer;
  final String bankId;

  const GeneratedQuestionsChoiceDialog({
    super.key,
    required this.serializer,
    required this.bankId,
  });

  @override
  State<GeneratedQuestionsChoiceDialog> createState() =>
      _GeneratedQuestionsChoiceDialogState();
}

class _GeneratedQuestionsChoiceDialogState
    extends State<GeneratedQuestionsChoiceDialog> {
  late List<bool> mcqSelected;
  late List<bool> msqSelected;
  late List<bool> natSelected;
  late List<bool> subjectiveSelected;

  @override
  void initState() {
    super.initState();
    mcqSelected = List.filled(widget.serializer.mcqs.length, false);
    msqSelected = List.filled(widget.serializer.msqs.length, false);
    natSelected = List.filled(widget.serializer.nats.length, false);
    subjectiveSelected = List.filled(
      widget.serializer.subjectives.length,
      false,
    );
  }

  void _toggleSelection(List<bool> selected, int index) {
    setState(() {
      selected[index] = !selected[index];
    });
  }

  void _saveSelectedQuestions() {
    final selectedMcqs = <MCQ>[];
    final selectedMsqs = <MSQ>[];
    final selectedNats = <NAT>[];
    final selectedSubjectives = <Subjective>[];

    for (int i = 0; i < mcqSelected.length; i++) {
      if (mcqSelected[i]) selectedMcqs.add(widget.serializer.mcqs[i]);
    }
    for (int i = 0; i < msqSelected.length; i++) {
      if (msqSelected[i]) selectedMsqs.add(widget.serializer.msqs[i]);
    }
    for (int i = 0; i < natSelected.length; i++) {
      if (natSelected[i]) selectedNats.add(widget.serializer.nats[i]);
    }
    for (int i = 0; i < subjectiveSelected.length; i++) {
      if (subjectiveSelected[i]) {
        selectedSubjectives.add(widget.serializer.subjectives[i]);
      }
    }

    if (selectedMcqs.isNotEmpty) {
      context.read<MCQBloc>().add(SaveBulkMCQs(selectedMcqs));
    }
    if (selectedMsqs.isNotEmpty) {
      context.read<MSQBloc>().add(SaveBulkMSQs(selectedMsqs));
    }
    if (selectedNats.isNotEmpty) {
      context.read<NATBloc>().add(SaveBulkNATs(selectedNats));
    }
    if (selectedSubjectives.isNotEmpty) {
      context.read<SubjectiveBloc>().add(SaveBulkSubjectives(selectedSubjectives));
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected questions are being saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
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
                Text('Select Generated Questions', style: GoogleFonts.jost(fontSize: 56, fontWeight: FontWeight.w400)),
                Text(
                  'Select which generated questions you want to save to your bank.',
                  style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          'MCQs',
                          widget.serializer.mcqs,
                          mcqSelected,
                          (q, i) => _buildMCQTile(q as MCQ, mcqSelected, i),
                        ),
                        _buildSection(
                          'MSQs',
                          widget.serializer.msqs,
                          msqSelected,
                          (q, i) => _buildMSQTile(q as MSQ, msqSelected, i),
                        ),
                        _buildSection(
                          'NATs',
                          widget.serializer.nats,
                          natSelected,
                          (q, i) => _buildNATTile(q as NAT, natSelected, i),
                        ),
                        _buildSection(
                          'Subjectives',
                          widget.serializer.subjectives,
                          subjectiveSelected,
                          (q, i) => _buildSubjectiveTile(q as Subjective, subjectiveSelected, i),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
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
                      icon: Icon(Icons.save),
                      label: Text(
                        'Save Selected',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      onPressed: _saveSelectedQuestions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    String label,
    List questions,
    List<bool> selected,
    Widget Function(dynamic, int) tileBuilder,
  ) {
    if (questions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SizedBox(height: 10),
        ...List.generate(questions.length, (i) => tileBuilder(questions[i], i)),
        const Divider(height: 40),
      ],
    );
  }

  Widget _buildMCQTile(MCQ mcq, List<bool> selected, int i) {
    final isSelected = selected[i];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.teal : Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.teal.withValues(alpha: 0.08) : Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _toggleSelection(selected, i),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q. ${mcq.question}',
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
                itemCount: mcq.options.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (index == mcq.answerIndex)
                          ? Colors.green.shade100
                          : Colors.grey.shade200,
                    ),
                    child: Center(
                      child: Text(
                        mcq.options[index],
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
    );
  }

  Widget _buildMSQTile(MSQ msq, List<bool> selected, int i) {
    final isSelected = selected[i];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.teal : Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.teal.withValues(alpha: 0.08) : Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _toggleSelection(selected, i),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q. ${msq.question}',
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
                itemCount: msq.options.length,
                itemBuilder: (context, index) {
                  final isAnswer = msq.answerIndices.contains(index);
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
                        msq.options[index],
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
    );
  }

  Widget _buildNATTile(NAT nat, List<bool> selected, int i) {
    final isSelected = selected[i];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.teal : Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.teal.withValues(alpha: 0.08) : Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _toggleSelection(selected, i),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q. ${nat.question}',
                style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                'Answer: ${nat.answer}',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blueGrey),
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
    );
  }

  Widget _buildSubjectiveTile(Subjective subj, List<bool> selected, int i) {
    final isSelected = selected[i];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.teal : Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.teal.withValues(alpha: 0.08) : Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _toggleSelection(selected, i),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q. ${subj.question}',
                style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              // SizedBox(height: 10),
              // Text(
              //   'Expected Answer: ${subj.answer}',
              //   style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blueGrey),
              // ),
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
    );
  }
}
