import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/question_bank/question_bank_bloc.dart';

import '../../../models/question_bank.dart';

class QuestionBankPageMobile extends StatefulWidget {
  const QuestionBankPageMobile({super.key});

  @override
  State<QuestionBankPageMobile> createState() => _QuestionBankPageMobileState();
}

class _QuestionBankPageMobileState extends State<QuestionBankPageMobile> {
  final String _teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';
  String _currentSearchQuery = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<QuestionBankBloc>().add(InitializeQuestionBankPaging(teacherId: _teacherId));
  }

  void _performSearch(String query) {
    setState(() {
      _currentSearchQuery = query;
    });

    if (query.isEmpty) {
      // Reset to original list without search
      context.read<QuestionBankBloc>().add(InitializeQuestionBankPaging(teacherId: _teacherId));
    } else {
      // Perform search
      context.read<QuestionBankBloc>().add(
        SearchQuestionBanks(
          teacherId: _teacherId,
          searchQuery: query,
        ),
      );
    }
  }

  void _navigateToAddQuestionBankPage() {
    context.go('/add_question_bank');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _navigateToAddQuestionBankPage,
      //   child: const Icon(Icons.add),
      // ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search question banks...',
                prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
                suffixIcon: _currentSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _currentSearchQuery = '';
                          });
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Question Banks List
          Expanded(
            child: BlocBuilder<QuestionBankBloc, PagingState<int, QuestionBank>>(
              builder: (context, state) => PagedListView<int, QuestionBank>(
                state: state,
                fetchNextPage: () {
                  context.read<QuestionBankBloc>().add(
                    FetchNextQuestionBankPage(
                      teacherId: _teacherId,
                      searchQuery: _currentSearchQuery.isNotEmpty ? _currentSearchQuery : null,
                    ),
                  );
                },
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Topic: ${item.topic}',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to question bank details
                      },
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No question banks found',
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading question banks',
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.red[600]),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.read<QuestionBankBloc>().add(
                              InitializeQuestionBankPaging(teacherId: _teacherId),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
