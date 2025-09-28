import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/question_bank/question_bank_bloc.dart';
import '../../../models/question_bank.dart';
import 'components/question_bank_tile_mobile.dart';
import 'components/create_bank_dialog.dart';

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
      context.read<QuestionBankBloc>().add(InitializeQuestionBankPaging(teacherId: _teacherId));
    } else {
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

  Future<void> _showCreateQuestionBankDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateBankDialog(
          onCreate: (name, topic, tags) async {
            final repo = context.read<QuestionBankBloc>().repository;
            final response = await repo.createQuestionBank(name, topic, _teacherId, tags);
            if (response.statusCode == 200 || response.statusCode == 201) {
              context.read<QuestionBankBloc>().add(InitializeQuestionBankPaging(teacherId: _teacherId));
              return true;
            }
            return false;
          },
        );
      },
    );
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
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        title: Text('Question Banks', style: GoogleFonts.poppins(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateQuestionBankDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Bar (desktop style)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: SearchBar(
              controller: _searchController,
              onChanged: (value) {
                _performSearch(value);
              },
              leading: const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Icon(Icons.search),
              ),
              backgroundColor: WidgetStateProperty.all(Colors.white),
              hintText: "Search question banks",
              hintStyle: WidgetStateProperty.all(
                GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              trailing: _currentSearchQuery.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _currentSearchQuery = '';
                          });
                          _searchController.clear();
                          _performSearch('');
                        },
                      ),
                    ]
                  : null,
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
                  itemBuilder: (context, item, index) => QuestionBankTileMobile(bank: item),
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
