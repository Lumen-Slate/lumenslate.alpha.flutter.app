import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/dummy_data/question_bank.dart';
import '../../../models/question_bank.dart';
import 'components/question_bank_tile.dart';

class QuestionBankPageDesktop extends StatefulWidget {
  const QuestionBankPageDesktop({super.key});

  @override
  QuestionBankPageDesktopState createState() => QuestionBankPageDesktopState();
}

class QuestionBankPageDesktopState extends State<QuestionBankPageDesktop> {
  List<QuestionBank> filteredQuestionBanks = dummyQuestionBanks;
  String searchQuery = "";

  void _filterQuestionBanks(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredQuestionBanks = dummyQuestionBanks.where((bank) {
        return bank.name.toLowerCase().contains(searchQuery) || bank.topic.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToAddQuestionBankPage() {
    context.go('/add_question_bank');
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 1920,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddQuestionBankPage,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    "Question Banks",
                    maxLines: 2,
                    minFontSize: 80,
                    style: GoogleFonts.poppins(
                      fontSize: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Question Banks List Container
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            // Search Bar
                            Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onChanged: _filterQuestionBanks,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: const Icon(Icons.search),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(Colors.white),
                                    hintText: "Search question banks",
                                    hintStyle: WidgetStateProperty.all(
                                      GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Question Banks List
                            SizedBox(
                              height: 580, // Fixed height for ListView
                              child: ListView.separated(
                                itemCount: filteredQuestionBanks.length,
                                itemBuilder: (context, index) {
                                  final bank = filteredQuestionBanks[index];
                                  return QuestionBankTile(bank: bank);
                                },
                                separatorBuilder: (context, index) => const SizedBox(height: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Gap between columns
                    const SizedBox(width: 50),
                    // Right Container for Info Panel
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 700,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 30,
                          children: [
                            Text(
                              'Info Card',
                              style: GoogleFonts.jost(fontSize: 42, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Total Banks: ${dummyQuestionBanks.length}',
                              style: GoogleFonts.poppins(fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
