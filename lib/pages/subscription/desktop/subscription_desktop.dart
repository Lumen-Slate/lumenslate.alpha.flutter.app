import 'package:flutter/material.dart';

class SubscriptionDesktop extends StatelessWidget {
  const SubscriptionDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Feature')),
            DataColumn(label: Text('Free Tier')),
            DataColumn(label: Text('Private Tutor Plan')),
            DataColumn(label: Text('Multi-Classroom Plan')),
            DataColumn(label: Text('School & Enterprise Plan')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Price')),
              DataCell(Text('₹0')),
              DataCell(Text('₹299 / month\n(₹2,999 / year)')),
              DataCell(Text('₹499 / user / month\n(₹4,999 / year)')),
              DataCell(Text('Custom Pricing\n(Contact Us)')),
            ]),
            DataRow(cells: [
              DataCell(Text('Recommended For')),
              DataCell(Text('Personal Trial')),
              DataCell(Text('Teaching one class')),
              DataCell(Text('Teachers teaching multiple classes')),
              DataCell(Text('Schools, Universities & Large Institutions')),
            ]),
            DataRow(cells: [
              DataCell(Text('Max Teachers per classroom')),
              DataCell(Text('1 Account')),
              DataCell(Text('5 Account')),
              DataCell(Text('10 accounts')),
              DataCell(Text('Custom / Unlimited')),
            ]),
            DataRow(cells: [
              DataCell(Text('Classroom count')),
              DataCell(Text('—')),
              DataCell(Text('2 Classroom')),
              DataCell(Text('5 Classrooms')),
              DataCell(Text('Unlimited')),
            ]),
            DataRow(cells: [
              DataCell(Text('Students per Classroom')),
              DataCell(Text('—')),
              DataCell(Text('Up to 40 Students')),
              DataCell(Text('Up to 60 Students')),
              DataCell(Text('Custom')),
            ]),
            DataRow(cells: [
              DataCell(Text('Collaborative Features')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('__')),
              DataCell(Text('Question Bank Sharing')),
            ]),
            DataRow(cells: [
              DataCell(Text('Total Question Banks')),
              DataCell(Text('1')),
              DataCell(Text('10')),
              DataCell(Text('25')),
              DataCell(Text('Unlimited')),
            ]),
            DataRow(cells: [
              DataCell(Text('Total Questions')),
              DataCell(Text('30')),
              DataCell(Text('500')),
              DataCell(Text('1,500')),
              DataCell(Text('Unlimited')),
            ]),
            DataRow(cells: [
              DataCell(Text('Assignment Exports')),
              DataCell(Text('5 exports/day')),
              DataCell(Text('Unlimited')),
              DataCell(Text('Unlimited')),
              DataCell(Text('Unlimited')),
            ]),
            DataRow(cells: [
              DataCell(Text('AI Agent Usage (Independent Agent Uses)')),
              DataCell(Text('10 uses/day')),
              DataCell(Text('100 uses/month')),
              DataCell(Text('250 uses/month')),
              DataCell(Text('Custom Volume & Rate Limits')),
            ]),
            DataRow(cells: [
              DataCell(Text('AI Agent Usage (Lumen Agent Uses)')),
              DataCell(Text('10 uses/day')),
              DataCell(Text('100 uses/month')),
              DataCell(Text('250 uses/month')),
              DataCell(Text('Custom Volume & Rate Limits')),
            ]),
            DataRow(cells: [
              DataCell(Text('RAG Agent')),
              DataCell(Text('5 uses/day')),
              DataCell(Text('100 uses/month')),
              DataCell(Text('250 uses/month')),
              DataCell(Text('Custom Volume & Rate Limits')),
            ]),
            DataRow(cells: [
              DataCell(Text('RAG Document Uploads')),
              DataCell(Text('1')),
              DataCell(Text('15')),
              DataCell(Text('50')),
              DataCell(Text('Unlimited')),
            ]),
            DataRow(cells: [
              DataCell(Text('Admin Dashboard')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('✔')),
            ]),
            DataRow(cells: [
              DataCell(Text('Custom Branding')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('✔ (White-Labeling)')),
            ]),
            DataRow(cells: [
              DataCell(Text('Integrations & API')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('—')),
              DataCell(Text('✔ (LMS & API Access)')),
            ]),
            DataRow(cells: [
              DataCell(Text('Support Level')),
              DataCell(Text('Community Forum')),
              DataCell(Text('Priority Email')),
              DataCell(Text('Dedicated Chat & Email')),
              DataCell(Text('Dedicated Account Manager & Onboarding')),
            ]),
          ],
        ),
      ),
    );
  }
}

