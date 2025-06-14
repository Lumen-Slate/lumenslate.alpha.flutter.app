import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../serializers/rag_agent_serializers/rag_generated_questions_serializer.dart';
import '../../../../models/questions/mcq.dart';
import '../../../../models/questions/msq.dart';
import '../../../../models/questions/nat.dart';
import '../../../../models/questions/subjective.dart';
import '../../../../blocs/mcq/mcq_bloc.dart';
import '../../../../blocs/msq/msq_bloc.dart';

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
    mcqSelected = List.filled(widget.serializer.mcqs.length, true);
    msqSelected = List.filled(widget.serializer.msqs.length, true);
    natSelected = List.filled(widget.serializer.nats.length, true);
    subjectiveSelected = List.filled(
      widget.serializer.subjectives.length,
      true,
    );
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
      if (subjectiveSelected[i])
        selectedSubjectives.add(widget.serializer.subjectives[i]);
    }

    if (selectedMcqs.isNotEmpty) {
      context.read<MCQBloc>().add(SaveBulkMCQs(selectedMcqs));
    }
    if (selectedMsqs.isNotEmpty) {
      context.read<MSQBloc>().add(SaveBulkMSQs(selectedMsqs));
    }
    // if (selectedNats.isNotEmpty) {
    //   context.read<NATBloc>().add(SaveBulkNATs(selectedNats));
    // }
    // if (selectedSubjectives.isNotEmpty) {
    //   context.read<SubjectiveBloc>().add(SaveBulkSubjectives(selectedSubjectives));
    // }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected questions are being saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Questions to Save'),
      content: SizedBox(
        width: 500,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('MCQs', widget.serializer.mcqs, mcqSelected),
              _buildSection('MSQs', widget.serializer.msqs, msqSelected),
              _buildSection('NATs', widget.serializer.nats, natSelected),
              _buildSection(
                'Subjectives',
                widget.serializer.subjectives,
                subjectiveSelected,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Save Selected'),
          onPressed: _saveSelectedQuestions,
        ),
      ],
    );
  }

  Widget _buildSection(String label, List questions, List<bool> selected) {
    if (questions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...List.generate(questions.length, (i) {
          final q = questions[i];
          return CheckboxListTile(
            value: selected[i],
            onChanged: (val) {
              setState(() {
                selected[i] = val ?? false;
              });
            },
            title: Text(
              q is MCQ
                  ? q.question
                  : q is MSQ
                  ? q.question
                  : q is NAT
                  ? q.question
                  : q is Subjective
                  ? q.question
                  : q.toString(),
            ),
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
        const Divider(),
      ],
    );
  }
}
