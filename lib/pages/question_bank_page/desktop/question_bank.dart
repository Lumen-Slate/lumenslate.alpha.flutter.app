import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/question_bank/question_bank_bloc.dart';

import '../../../constants/app_constants.dart';
import '../../../models/question_bank.dart';
import 'components/question_bank_tile.dart';

class QuestionBankPageDesktop extends StatefulWidget {
  const QuestionBankPageDesktop({super.key});

  @override
  QuestionBankPageDesktopState createState() => QuestionBankPageDesktopState();
}

class QuestionBankPageDesktopState extends State<QuestionBankPageDesktop> {

  final String _teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => context.go('/add_question_bank'),
        //   child: Icon(Icons.add),
        // ),
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
                    style: GoogleFonts.poppins(fontSize: 80),
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
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            // Search Bar (disabled for now, as pagination is server-side)
                            Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onChanged: (_) {},
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: const Icon(Icons.search),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(Colors.white),
                                    hintText: "Search question banks",
                                    hintStyle: WidgetStateProperty.all(
                                      GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                    ),
                                    enabled: false, // Disabled for paginated list
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Paginated Question Banks List
                            SizedBox(
                              height: 580,
                              child: BlocBuilder<QuestionBankBloc, PagingState<int, QuestionBank>>(
                                builder: (context, state) => PagedListView<int, QuestionBank>(
                                  state: state,
                                  fetchNextPage: () {
                                    final authState = context.read<AuthBloc>().state;
                                    // if (authState is AuthSuccess) {
                                    if (true) {
                                      // final String teacherId = authState.teacher.id;
                                      context.read<QuestionBankBloc>().add(
                                        FetchNextQuestionBankPage(teacherId: _teacherId),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text('Please log in to view question banks')));
                                    }
                                  },
                                  builderDelegate: PagedChildBuilderDelegate(
                                    itemBuilder: (context, item, index) => QuestionBankTile(bank: item),
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        Center(child: Text('No question banks found')),
                                    firstPageErrorIndicatorBuilder: (context) =>
                                        Center(child: Text('Error loading question banks')),
                                  ),
                                ),
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
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Info Card', style: GoogleFonts.jost(fontSize: 42, fontWeight: FontWeight.w400)),
                            // You may want to update this to show total from API
                            SizedBox(height: 20),
                            Text('Total Banks: 6', style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.w400)),
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
