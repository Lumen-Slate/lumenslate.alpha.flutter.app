import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';


import '../../../constants/dummy_data/questions/mcq.dart';
import '../../../constants/dummy_data/questions/msq.dart';
import '../../../constants/dummy_data/questions/nat.dart';
import '../../../constants/dummy_data/questions/subjective.dart';
import '../../../models/questions/mcq.dart';
import '../../../common/widgets/search_dropdown.dart';
import 'components/mcq_tile.dart';
class QuestionsDesktop extends StatefulWidget {
  const QuestionsDesktop({super.key});

  @override
  QuestionsDesktopState createState() => QuestionsDesktopState();
}

class QuestionsDesktopState extends State<QuestionsDesktop> {
  List<dynamic> allQuestions = [...dummyMCQs, ...dummyMSQs, ...dummyNATs, ...dummySubjectives];
  List<dynamic> filteredQuestions = [];
  String searchQuery = "";
  String searchMode = "Search by question";
  String selectedType = "All";
  double minPoints = 0;
  double maxPoints = 100;

  @override
  void initState() {
    super.initState();
    filteredQuestions = allQuestions;
  }

  void _filterQuestions(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredQuestions = allQuestions.where((question) {
        bool matchesSearch =
            searchMode == "Search by question" ? question.mcq.toLowerCase().contains(searchQuery) : true;
        bool matchesPoints =
            searchMode == "Filter by points" ? (question.points >= minPoints && question.points <= maxPoints) : true;
        bool matchesType = selectedType == "All" || question.runtimeType.toString() == selectedType;
        return matchesSearch && matchesPoints && matchesType;
      }).toList();
    });
  }

  void _updateSearchMode(String mode) {
    setState(() {
      searchMode = mode;
      searchQuery = "";
      filteredQuestions = allQuestions;

      if (mode == "Filter by points") {
        minPoints = 0;
        maxPoints = 100;
        _applyFilters();
      }
    });
  }

  void _updateQuestionType(String type) {
    setState(() {
      selectedType = type;
      _applyFilters();
    });
  }

  // void _refreshQuestions() {
  //   setState(() {
  //     allQuestions = [...dummyMCQs, ...dummyMSQs, ...dummyNATs, ...dummySubjectives];
  //     _applyFilters();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 1920,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/add-question'),
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
                    "Questions",
                    maxLines: 2,
                    minFontSize: 80,
                    style: GoogleFonts.poppins(
                      fontSize: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 14,
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onChanged: _filterQuestions,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: const Icon(Icons.search),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(Colors.white),
                                    hintText: "Search question",
                                    hintStyle: WidgetStateProperty.all(
                                      GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  iconSize: 36,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.white),
                                    elevation: WidgetStateProperty.all(5),
                                    shadowColor: WidgetStateProperty.all(Colors.grey[300]),
                                  ),
                                  onSelected: _updateSearchMode,
                                  icon: Icon(Icons.filter_list, color: Colors.teal[700]),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: "Search by question",
                                      child: Text("Search by question"),
                                    ),
                                    PopupMenuItem(
                                      value: "Filter by points",
                                      child: Text("Filter by points"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 150,
                                  child: SearchDropdown(
                                    items: ["All", "MCQ", "MSQ", "NAT", "Subjective"],
                                    selectedValue: selectedType,
                                    onChanged: (value) => _updateQuestionType(value!),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 600,
                              child: ListView.separated(
                                itemCount: filteredQuestions.length,
                                itemBuilder: (context, index) {
                                  final question = filteredQuestions[index];
                                  if (question is MCQ) {
                                    return MCQTile(mcq: question);
                                  }
                                  return null;
                                },
                                separatorBuilder: (context, index) => const SizedBox(height: 20),
                              ),
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
