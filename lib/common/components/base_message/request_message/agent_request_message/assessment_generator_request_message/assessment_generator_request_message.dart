import 'package:flutter/material.dart';
import '../agent_request_message.dart';



final class AssessmentGeneratorRequestMessage extends StatelessWidget implements AgentRequestMessage {
  const AssessmentGeneratorRequestMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(title: Text("Assessment Generator Request"));
  }
}

