import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../../common/widgets/highlight_text.dart';
import '../../../common/widgets/search_dropdown.dart';

class AddQuestionDesktop extends StatefulWidget {
  const AddQuestionDesktop({super.key});

  @override
  State<AddQuestionDesktop> createState() => _AddQuestionDesktopState();
}

class _AddQuestionDesktopState extends State<AddQuestionDesktop> {

  late TextEditingController _questionController;
  late LinkedScrollControllerGroup _scrollControllers;
  late ScrollController _questionScrollController;
  late ScrollController _formattedQuestionViewScrollController;

  final highlights = [
    HighlightSegment(
      start: 0,
      end: 7,
      style: GoogleFonts.poppins(fontSize: 21, color: Colors.white),
      highlightColor: Colors.blue,
      onTap: () {
        Logger().i('Tapped on "Flutter"');
      },
    ),
    HighlightSegment(
      start: 19,
      end: 28,
      style: GoogleFonts.poppins(fontSize: 21, color: Colors.white),
      highlightColor: Colors.red,
      onTap: () {
        Logger().i('Tapped on "supports"');
      },
    ),
    HighlightSegment(
      start: 33,
      end: 40,
      style: GoogleFonts.poppins(fontSize: 21, color: Colors.white),
      highlightColor: Colors.green,
      onTap: () {
        Logger().i('Tapped on "Android"');
      },
    ),
  ];

  @override
  void initState() {
    _scrollControllers = LinkedScrollControllerGroup();
    _questionController = TextEditingController();
    _questionScrollController = _scrollControllers.addAndGet();
    _formattedQuestionViewScrollController = _scrollControllers.addAndGet();
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _questionScrollController.dispose();
    _formattedQuestionViewScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 1920,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    'Add Question',
                    maxLines: 2,
                    minFontSize: 80,
                    style: GoogleFonts.poppins(
                      fontSize: 80,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 730,
                        margin: const EdgeInsets.only(right: 50),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Q.',
                                  style: GoogleFonts.jost(fontSize: 32),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        scrollController: _questionScrollController,
                                        controller: _questionController,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter your question here',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding: const EdgeInsets.all(30),
                                        ),
                                        maxLines: 8,
                                        style: GoogleFonts.poppins(fontSize: 21),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        padding: const EdgeInsets.all(30),
                                        width: double.infinity,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: SingleChildScrollView(
                                          controller: _formattedQuestionViewScrollController,
                                          child: HighlightAbleText(
                                            text: _questionController.text,
                                            highlights: highlights,
                                            defaultTextStyle: GoogleFonts.poppins(fontSize: 21),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 730,
                        margin: const EdgeInsets.only(left: 50),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Choose Question Bank',
                              style: GoogleFonts.jost(fontSize: 32),
                            ),
                            SizedBox(height: 30),
                            SearchDropdown(
                              items: ['Bank 1', 'Bank 2', 'Bank 3', 'Bank 4', 'Bank 5'],
                              selectedValue: 'MCQ',
                              onChanged: (value) {},
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Variables',
                              style: GoogleFonts.jost(fontSize: 32),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
