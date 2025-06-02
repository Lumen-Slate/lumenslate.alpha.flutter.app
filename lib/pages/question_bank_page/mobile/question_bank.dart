import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/dummy_data/question_bank.dart';
import '../../../models/question_bank.dart';

class QuestionBankPageMobile extends StatefulWidget {
  const QuestionBankPageMobile({super.key});

  @override
  State<QuestionBankPageMobile> createState() => _QuestionBankPageMobileState();
}

class _QuestionBankPageMobileState extends State<QuestionBankPageMobile> {
  List<QuestionBank> filteredQuestionBanks = dummyQuestionBanks;
  String searchQuery = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _filterQuestionBanks(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredQuestionBanks = dummyQuestionBanks.where((bank) {
        return bank.name.toLowerCase().contains(searchQuery) ||
            bank.topic.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToAddQuestionBankPage() {
    context.go('/add_question_bank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Question Banks',
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard', style: GoogleFonts.poppins(fontSize: 16)),
              onTap: () => context.go('/teacher-dashboard'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Question Banks', style: GoogleFonts.poppins(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddQuestionBankPage,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Search Field
          TextField(
            onChanged: _filterQuestionBanks,
            decoration: InputDecoration(
              hintText: 'Search by chapter or topic...',
              prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Info Panel
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Info',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Total Banks: ${dummyQuestionBanks.length}',
                    style: GoogleFonts.poppins(fontSize: 16)),
                const SizedBox(height: 5),
                Text('Filtered Banks: ${filteredQuestionBanks.length}',
                    style: GoogleFonts.poppins(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Question Banks List
          ...filteredQuestionBanks.map((bank) => Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                bank.name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Topic: ${bank.topic}',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
