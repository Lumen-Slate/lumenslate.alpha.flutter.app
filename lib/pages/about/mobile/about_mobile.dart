import 'package:flutter/material.dart';

class AboutMobilePage extends StatelessWidget {
  const AboutMobilePage({Key? key}) : super(key: key);

  final List<Map<String, String>> faqs = const [
    {
      'question': 'What is LumenSlate?',
      'answer': 'LumenSlate is an AI-powered platform for teachers, students, and institutions to manage classrooms, assignments, and educational content.'
    },
    {
      'question': 'Who can use LumenSlate?',
      'answer': 'Teachers, students, schools, and educational organizations can use LumenSlate to streamline their teaching and learning processes.'
    },
    {
      'question': 'How do I get support?',
      'answer': 'You can reach out to our support team via the contact email below.'
    },
    {
      'question': 'Can I collaborate with LumenSlate?',
      'answer': 'Yes! For partnerships and collaborations, contact us at the email below.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...faqs.map((faq) => ExpansionTile(
                      title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(faq['answer']!),
                        ),
                      ],
                    )),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Contact Us',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.email, color: Colors.teal),
                    SizedBox(width: 8),
                    SelectableText(
                      'partnership.hareandtortoise@gmail.com',
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

