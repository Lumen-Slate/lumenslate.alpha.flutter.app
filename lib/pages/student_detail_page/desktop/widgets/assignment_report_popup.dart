import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/students.dart';

class AssignmentReportPopupDesktop extends StatelessWidget {
  final Student student;
  final String classroomId;

  const AssignmentReportPopupDesktop({
    super.key,
    required this.student,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(40),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  // Assignment Icon
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange[100],
                    child: Icon(
                      Icons.assignment,
                      size: 32,
                      color: Colors.orange[800],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Assignment Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Physics Assignment #1 - Assignment Report',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Student: ${student.name} • Roll No: ${student.rollNo}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close Button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 28,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assignment Overview Section
                    _buildAssignmentOverviewSection(),
                    const SizedBox(height: 32),
                    
                    // Question-wise Performance Section
                    _buildQuestionWisePerformanceSection(),
                    const SizedBox(height: 32),
                    
                    // Performance Analysis Section
                    _buildPerformanceAnalysisSection(),
                    const SizedBox(height: 32),
                    
                    // Recommendations Section
                    _buildRecommendationsSection(),
                  ],
                ),
              ),
            ),
            // Footer Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement print functionality
                    },
                    icon: const Icon(Icons.print),
                    label: Text(
                      'Print Report',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement export functionality
                    },
                    icon: const Icon(Icons.file_download),
                    label: Text(
                      'Export PDF',
                      style: GoogleFonts.poppins(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
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

  Widget _buildAssignmentOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assignment Overview',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Total Score',
                      value: '85/100',
                      subtitle: '85% - Grade A',
                      icon: Icons.grade,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Time Taken',
                      value: '45 min',
                      subtitle: 'Out of 60 min',
                      icon: Icons.timer,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Submission Date',
                      value: 'Jan 15',
                      subtitle: '2025 at 2:30 PM',
                      icon: Icons.calendar_today,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Class Rank',
                      value: '#3',
                      subtitle: 'Out of 45 students',
                      icon: Icons.emoji_events,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionWisePerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question-wise Performance',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        
        // MCQ Section
        _buildQuestionTypeSection(
          'Multiple Choice Questions (MCQ)',
          '8/10 Correct',
          Colors.blue,
          [
            _buildQuestionRow('Q1', 'Newton\'s First Law', 'Correct', '5/5', Colors.green),
            _buildQuestionRow('Q2', 'Force and Acceleration', 'Correct', '5/5', Colors.green),
            _buildQuestionRow('Q3', 'Momentum Conservation', 'Wrong', '0/5', Colors.red),
            _buildQuestionRow('Q4', 'Work and Energy', 'Correct', '5/5', Colors.green),
            _buildQuestionRow('Q5', 'Gravitational Force', 'Wrong', '0/5', Colors.red),
          ],
        ),
        const SizedBox(height: 20),
        
        // MSQ Section
        _buildQuestionTypeSection(
          'Multiple Select Questions (MSQ)',
          '2/3 Correct',
          Colors.green,
          [
            _buildQuestionRow('Q6', 'Types of Forces', 'Partial', '3/5', Colors.orange),
            _buildQuestionRow('Q7', 'Energy Conservation', 'Correct', '5/5', Colors.green),
            _buildQuestionRow('Q8', 'Motion in 2D', 'Correct', '5/5', Colors.green),
          ],
        ),
        const SizedBox(height: 20),
        
        // NAT Section
        _buildQuestionTypeSection(
          'Numerical Answer Type (NAT)',
          '2/2 Correct',
          Colors.orange,
          [
            _buildQuestionRow('Q9', 'Calculate Velocity', 'Correct', '10/10', Colors.green),
            _buildQuestionRow('Q10', 'Find Acceleration', 'Correct', '10/10', Colors.green),
          ],
        ),
        const SizedBox(height: 20),
        
        // Subjective Section
        _buildQuestionTypeSection(
          'Subjective Questions',
          '1/2 Questions',
          Colors.purple,
          [
            _buildQuestionRow('Q11', 'Explain Newton\'s Laws', 'Good', '7/10', Colors.green),
            _buildQuestionRow('Q12', 'Derive Kinematic Equation', 'Needs Improvement', '3/10', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Analysis',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildAnalysisCard(
                'Strengths',
                [
                  'Strong understanding of basic concepts',
                  'Excellent numerical problem solving',
                  'Good application of formulas',
                  'Clear explanation in subjective answers'
                ],
                Colors.green,
                Icons.star,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalysisCard(
                'Areas for Improvement',
                [
                  'Concept of momentum needs practice',
                  'Multiple select questions accuracy',
                  'Mathematical derivations',
                  'Time management in complex problems'
                ],
                Colors.orange,
                Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          'Next Steps',
          [
            'Review momentum conservation principles with examples',
            'Practice more multiple select questions',
            'Focus on mathematical derivation techniques',
            'Work on step-by-step problem solving approach',
            'Schedule regular practice sessions for weak areas'
          ],
          Colors.blue,
          Icons.lightbulb,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTypeSection(String title, String summary, Color color, List<Widget> questions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.quiz, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      summary,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...questions,
        ],
      ),
    );
  }

  Widget _buildQuestionRow(String questionNo, String question, String status, String score, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                questionNo,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              question,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            score,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, List<String> items, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
