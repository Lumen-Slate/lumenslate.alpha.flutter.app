import 'package:flutter/material.dart';
import '../agent_request_message.dart';


final class AssignmentGeneratorGeneralRequestMessage extends StatelessWidget implements AgentRequestMessage {
  const AssignmentGeneratorGeneralRequestMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(title: Text("Assignment Generator General Request"));
  }
}