import 'package:flutter/material.dart';
import '../agent_request_message.dart';



final class AssignmentGeneratorTailoredRequestMessage extends StatefulWidget implements AgentRequestMessage {
  const AssignmentGeneratorTailoredRequestMessage({super.key});

  @override
  State<AssignmentGeneratorTailoredRequestMessage> createState() => _AssignmentGeneratorTailoredRequestMessageState();
}

class _AssignmentGeneratorTailoredRequestMessageState extends State<AssignmentGeneratorTailoredRequestMessage> {
  @override
  Widget build(BuildContext context) {
    return const ListTile(title: Text("Assignment Generator Tailored Request"));
  }
}
