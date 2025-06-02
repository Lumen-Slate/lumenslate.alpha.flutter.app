import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../../../../common/widgets/highlight_text.dart';
import '../../../common/widgets/search_dropdown.dart';

class AddQuestionMobile extends StatefulWidget {
  const AddQuestionMobile({super.key});

  @override
  State<AddQuestionMobile> createState() => _AddQuestionMobileState();
}

class _AddQuestionMobileState extends State<AddQuestionMobile> {
  late final TextEditingController _questionController;
  final ScrollController _questionScrollController = ScrollController();
  final ScrollController _formattedScrollController = ScrollController();

  final highlights = [
    HighlightSegment(
      start: 0,
      end: 7,
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      highlightColor: Colors.blue,
      onTap: () {
        Logger().i('Tapped on "Flutter"');
      },
    ),
    HighlightSegment(
      start: 19,
      end: 28,
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      highlightColor: Colors.red,
      onTap: () {
        Logger().i('Tapped on "supports"');
      },
    ),
    HighlightSegment(
      start: 33,
      end: 40,
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      highlightColor: Colors.green,
      onTap: () {
        Logger().i('Tapped on "Android"');
      },
    ),
  ];

  @override
  void initState() {
    _questionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _questionScrollController.dispose();
    _formattedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question', style: GoogleFonts.poppins(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title
            Align(
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                'Add Question',
                maxLines: 1,
                minFontSize: 32,
                style: GoogleFonts.poppins(fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            // Question Bank Selector
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose Question Bank', style: GoogleFonts.jost(fontSize: 22)),
                const SizedBox(height: 12),
                SearchDropdown(
                  items: ['Bank 1', 'Bank 2', 'Bank 3', 'Bank 4'],
                  selectedValue: 'Bank 1',
                  onChanged: (val) {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Question Entry
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Q.', style: GoogleFonts.jost(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _questionController,
                          scrollController: _questionScrollController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Enter your question here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          maxLines: 6,
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      controller: _formattedScrollController,
                      child: HighlightAbleText(
                        text: _questionController.text,
                        highlights: highlights,
                        defaultTextStyle: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
