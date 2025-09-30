import 'package:flutter/material.dart';

class AboutDesktopPage extends StatelessWidget {
  const AboutDesktopPage({Key? key}) : super(key: key);

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
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ...faqs.map((faq) => ExpansionTile(
                        title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(faq['answer']!, style: const TextStyle(fontSize: 16)),
                          ),
                        ],
                      )),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 24),
                  const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.email, color: Colors.teal, size: 28),
                      SizedBox(width: 12),
                      SelectableText(
                        'partnership.hareandtortoise@gmail.com',
                        style: TextStyle(fontSize: 18, color: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

