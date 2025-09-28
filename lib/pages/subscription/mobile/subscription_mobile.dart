import 'package:flutter/material.dart';

class SubscriptionMobile extends StatelessWidget {
  const SubscriptionMobile({super.key});

  final List<Map<String, String>> plans = const [
    {
      'title': 'Free Tier',
      'price': '₹0',
      'recommended': 'Personal Trial',
      'teachers': '1 Account',
      'classrooms': '—',
      'students': '—',
      'questionBanks': '1',
      'questions': '30',
      'exports': '5 exports/day',
      'aiAgent': '10 uses/day',
      'lumenAgent': '10 uses/day',
      'ragAgent': '5 uses/day',
      'ragUploads': '1',
      'admin': '—',
      'branding': '—',
      'api': '—',
      'support': 'Community Forum',
      'collab': '—',
    },
    {
      'title': 'Private Tutor Plan',
      'price': '₹299 / month\n(₹2,999 / year)',
      'recommended': 'Teaching one class',
      'teachers': '5 Account',
      'classrooms': '2 Classroom',
      'students': 'Up to 40 Students',
      'questionBanks': '10',
      'questions': '500',
      'exports': 'Unlimited',
      'aiAgent': '100 uses/month',
      'lumenAgent': '100 uses/month',
      'ragAgent': '100 uses/month',
      'ragUploads': '15',
      'admin': '—',
      'branding': '—',
      'api': '—',
      'support': 'Priority Email',
      'collab': '—',
    },
    {
      'title': 'Multi-Classroom Plan',
      'price': '₹499 / user / month\n(₹4,999 / year)',
      'recommended': 'Teachers teaching multiple classes',
      'teachers': '10 accounts',
      'classrooms': '5 Classrooms',
      'students': 'Up to 60 Students',
      'questionBanks': '25',
      'questions': '1,500',
      'exports': 'Unlimited',
      'aiAgent': '250 uses/month',
      'lumenAgent': '250 uses/month',
      'ragAgent': '250 uses/month',
      'ragUploads': '50',
      'admin': '—',
      'branding': '—',
      'api': '—',
      'support': 'Dedicated Chat & Email',
      'collab': '__',
    },
    {
      'title': 'School & Enterprise Plan',
      'price': 'Custom Pricing\n(Contact Us)',
      'recommended': 'Schools, Universities & Large Institutions',
      'teachers': 'Custom / Unlimited',
      'classrooms': 'Unlimited',
      'students': 'Custom',
      'questionBanks': 'Unlimited',
      'questions': 'Unlimited',
      'exports': 'Unlimited',
      'aiAgent': 'Custom Volume & Rate Limits',
      'lumenAgent': 'Custom Volume & Rate Limits',
      'ragAgent': 'Custom Volume & Rate Limits',
      'ragUploads': 'Unlimited',
      'admin': '✔',
      'branding': '✔ (White-Labeling)',
      'api': '✔ (LMS & API Access)',
      'support': 'Dedicated Account Manager & Onboarding',
      'collab': 'Question Bank Sharing',
    },
  ];

  final List<Map<String, String>> features = const [
    {'label': 'Recommended For', 'key': 'recommended'},
    {'label': 'Max Teachers per classroom', 'key': 'teachers'},
    {'label': 'Classroom count', 'key': 'classrooms'},
    {'label': 'Students per Classroom', 'key': 'students'},
    {'label': 'Collaborative Features', 'key': 'collab'},
    {'label': 'Total Question Banks', 'key': 'questionBanks'},
    {'label': 'Total Questions', 'key': 'questions'},
    {'label': 'Assignment Exports', 'key': 'exports'},
    {'label': 'AI Agent Usage (Independent Agent Uses)', 'key': 'aiAgent'},
    {'label': 'AI Agent Usage (Lumen Agent Uses)', 'key': 'lumenAgent'},
    {'label': 'RAG Agent', 'key': 'ragAgent'},
    {'label': 'RAG Document Uploads', 'key': 'ragUploads'},
    {'label': 'Admin Dashboard', 'key': 'admin'},
    {'label': 'Custom Branding', 'key': 'branding'},
    {'label': 'Integrations & API', 'key': 'api'},
    {'label': 'Support Level', 'key': 'support'},
  ];

  Color _planColor(int index) {
    switch (index) {
      case 0:
        return Colors.grey.shade200;
      case 1:
        return Colors.blue.shade50;
      case 2:
        return Colors.purple.shade50;
      case 3:
        return Colors.orange.shade50;
      default:
        return Colors.white;
    }
  }

  IconData _planIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_outline;
      case 1:
        return Icons.school_outlined;
      case 2:
        return Icons.groups_outlined;
      case 3:
        return Icons.business_outlined;
      default:
        return Icons.star_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF4FC3F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Subscription Plans',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the best plan for your needs',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final isRecommended = index == 1;
                return Card(
                  color: _planColor(index),
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(_planIcon(index), color: Colors.deepPurple, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              plan['title']!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                            ),
                            const Spacer(),
                            if (isRecommended)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Recommended',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plan['price']!,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Divider(height: 1, color: Colors.deepPurple.shade100),
                        const SizedBox(height: 10),
                        ...features.map(
                          (feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    feature['label']!,
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                                Text(
                                  plan[feature['key']] ?? '—',
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.deepPurple),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
