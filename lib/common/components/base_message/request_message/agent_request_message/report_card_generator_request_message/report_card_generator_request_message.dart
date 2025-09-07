import 'package:flutter/material.dart';
import '../agent_request_message.dart';



final class ReportCardGeneratorRequestMessage extends StatelessWidget implements AgentRequestMessage {
  const ReportCardGeneratorRequestMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(title: Text("Report Card Generator Request"));
  }
}
