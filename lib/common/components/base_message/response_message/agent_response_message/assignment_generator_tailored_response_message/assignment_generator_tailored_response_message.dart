import 'package:flutter/material.dart';
import '../agent_response_message.dart';



final class AssignmentGeneratorTailoredResponseMessage extends StatelessWidget implements AgentResponseMessage {
  const AssignmentGeneratorTailoredResponseMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(title: Text("Assignment Generator Tailored Response"));
  }
}
