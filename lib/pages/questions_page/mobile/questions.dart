import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/dummy_data/questions/mcq.dart';
import '../../../constants/dummy_data/questions/msq.dart';
import '../../../constants/dummy_data/questions/nat.dart';
import '../../../constants/dummy_data/questions/subjective.dart';
import '../../../models/questions/mcq.dart';
import '../../../models/questions/msq.dart';
import 'components/context_genenration_dialog.dart';
import 'components/mcq_variation_dialog.dart';
import 'components/msq_variation_dialog.dart';

class QuestionsMobile extends StatefulWidget {
  const QuestionsMobile({super.key});

  @override
  State<QuestionsMobile> createState() => _QuestionsMobileState();
}

class _QuestionsMobileState extends State<QuestionsMobile> {
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

  void _refreshQuestions() {
    setState(() {
      allQuestions = [...dummyMCQs, ...dummyMSQs, ...dummyNATs, ...dummySubjectives];
      _applyFilters();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Questions', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () => context.go('/teacher-dashboard_page'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Questions', style: GoogleFonts.poppins()),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-question'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search and Filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: _filterQuestions,
                  decoration: InputDecoration(
                    hintText: 'Search questions_page...',
                    prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                onSelected: _updateSearchMode,
                icon: Icon(Icons.filter_list, color: Colors.teal[700]),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: "Search by question", child: Text("Search by question")),
                  const PopupMenuItem(value: "Filter by points", child: Text("Filter by points")),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedType,
            isExpanded: true,
            onChanged: (value) => _updateQuestionType(value!),
            items: ["All", "MCQ", "MSQ", "NAT", "Subjective"]
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
          ),
          const SizedBox(height: 20),
          ...filteredQuestions.map((question) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text("Type: ${question.runtimeType}", style: GoogleFonts.poppins(fontSize: 14)),
                    Text("Points: ${question.points}", style: GoogleFonts.poppins(fontSize: 14)),
                    if (question is MCQ || question is MSQ) ...[
                      const SizedBox(height: 6),
                      Text("Options:", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                      ...question.options.asMap().entries.map((entry) => Text(
                          "${String.fromCharCode(97 + entry.key as int)}) ${entry.value}",
                          style: GoogleFonts.poppins(fontSize: 14))),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.lightbulb_outline),
                            label: const Text('Context'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade100,
                              foregroundColor: Colors.orange.shade800,
                            ),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => ContextGenerationDialogMobile(
                                  questionObject: question,
                                  type: question.runtimeType.toString(),
                                  id: question.id,
                                ),
                              );
                              _refreshQuestions();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (question is MCQ)
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.account_tree),
                              label: const Text('Variations'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                foregroundColor: Colors.blue.shade800,
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) => MCQVariationDialogMobile(mcq: question),
                                );
                                _refreshQuestions();
                              },
                            ),
                          ),
                        if (question is MSQ)
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.account_tree),
                              label: const Text('Variations'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                foregroundColor: Colors.blue.shade800,
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) => MSQVariationDialogMobile(msq: question),
                                );
                                _refreshQuestions();
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
