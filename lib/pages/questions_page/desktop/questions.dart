import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/questions/questions_bloc.dart';
import '../../../constants/app_constants.dart';
import '../../../models/questions/mcq.dart';
import '../../../models/questions/msq.dart';
import '../../../models/questions/nat.dart';
import '../../../models/questions/subjective.dart';
import '../../../common/widgets/search_dropdown.dart';

import 'components/question_tiles/mcq_tile.dart';
import 'components/question_tiles/msq_tile.dart';
import 'components/question_tiles/nat_tile.dart';
import 'components/question_tiles/subjective_tile.dart';

class QuestionsDesktop extends StatefulWidget {
  const QuestionsDesktop({super.key});

  @override
  QuestionsDesktopState createState() => QuestionsDesktopState();
}

class QuestionsDesktopState extends State<QuestionsDesktop> {
  List<dynamic> allQuestions = [];
  List<dynamic> filteredQuestions = [];
  String searchQuery = "";
  String searchMode = "Search by question";
  String selectedType = "All";
  double minPoints = 0;
  double maxPoints = 100;

  @override
  void initState() {
    context.read<QuestionsBloc>().add(const LoadQuestions());
    super.initState();
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
        bool matchesSearch = searchMode == "Search by question"
            ? question.question.toLowerCase().contains(searchQuery)
            : true;
        bool matchesPoints = searchMode == "Filter by points"
            ? (question.points >= minPoints && question.points <= maxPoints)
            : true;
        bool matchesType = selectedType == "All" || _getQuestionTypeName(question) == selectedType;
        return matchesSearch && matchesPoints && matchesType;
      }).toList();
    });
  }

  String _getQuestionTypeName(dynamic question) {
    if (question is MCQ) return "MCQ";
    if (question is MSQ) return "MSQ";
    if (question is NAT) return "NAT";
    if (question is Subjective) return "Subjective";
    return question.runtimeType.toString();
  }

  // void _updateSearchMode(String mode) {
  //   setState(() {
  //     searchMode = mode;
  //     searchQuery = "";
  //     filteredQuestions = allQuestions;
  //
  //     if (mode == "Filter by points") {
  //       minPoints = 0;
  //       maxPoints = 100;
  //       _applyFilters();
  //     }
  //   });
  // }

  void _updateQuestionType(String type) {
    setState(() {
      selectedType = type;
      _applyFilters();
    });
  }

  Widget _buildQuestionTile(dynamic question) {
    if (question is MCQ) {
      return MCQTile(mcq: question);
    } else if (question is MSQ) {
      return MSQTile(msq: question);
    } else if (question is NAT) {
      return NATTile(nat: question);
    } else if (question is Subjective) {
      return SubjectiveTile(subjective: question);
    }
    return Container(); // Fallback for unknown types
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/add-question'),
          child: Icon(Icons.add),
        ),
        body: BlocListener<QuestionsBloc, QuestionsState>(
          listener: (context, state) {
            if (state is QuestionsLoaded) {
              setState(() {
                allQuestions = state.questions;
                filteredQuestions = state.questions;
              });
            } else if (state is QuestionsFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error loading questions: ${state.error}')));
            }
          },
          child: SingleChildScrollView(
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
                      style: GoogleFonts.poppins(fontSize: 80),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
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
                                        GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  // PopupMenuButton<String>(
                                  //   iconSize: 36,
                                  //
                                  //   style: ButtonStyle(
                                  //     alignment: Alignment.center,
                                  //     backgroundColor: WidgetStateProperty.all(Colors.white),
                                  //     elevation: WidgetStateProperty.all(5),
                                  //     shadowColor: WidgetStateProperty.all(Colors.grey[300]),
                                  //   ),
                                  //   onSelected: _updateSearchMode,
                                  //   icon: Icon(Icons.filter_list, color: Colors.teal[700]),
                                  //   itemBuilder: (context) => [
                                  //     PopupMenuItem(value: "Search by question", child: Text("Search by question")),
                                  //     PopupMenuItem(value: "Filter by points", child: Text("Filter by points")),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    width: 150,
                                    height: 60,
                                    child: SearchDropdown(
                                      items: ["All", "MCQ", "MSQ", "NAT", "Subjective"],
                                      selectedValue: selectedType,
                                      searchEnabled: false,
                                      onChanged: (value) => _updateQuestionType(value!),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<QuestionsBloc, QuestionsState>(
                                builder: (context, state) {
                                  if (state is QuestionsLoading) {
                                    return SizedBox(
                                      height: 600,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(),
                                            const SizedBox(height: 16),
                                            Text('Loading questions...'),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return SizedBox(
                                    height: 600,
                                    child: ListView.separated(
                                      itemCount: filteredQuestions.length,
                                      itemBuilder: (context, index) {
                                        final question = filteredQuestions[index];
                                        return _buildQuestionTile(question);
                                      },
                                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                                    ),
                                  );
                                },
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
      ),
    );
  }
}
