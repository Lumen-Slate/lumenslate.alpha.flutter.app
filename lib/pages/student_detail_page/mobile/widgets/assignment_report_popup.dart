import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/students.dart';

class AssignmentReportPopupMobile extends StatelessWidget {
  final Student student;
  final String classroomId;

  const AssignmentReportPopupMobile({
    super.key,
    required this.student,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment Report',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'Physics Assignment #1',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'print':
                  // TODO: Implement print functionality
                  break;
                case 'export':
                  // TODO: Implement export functionality
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'print',
                child: Row(
                  children: [
                    const Icon(Icons.print, size: 20),
                    const SizedBox(width: 8),
                    Text('Print Report', style: GoogleFonts.poppins()),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.file_download, size: 20),
                    const SizedBox(width: 8),
                    Text('Export PDF', style: GoogleFonts.poppins()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Card
            _buildStudentInfoCard(),
            const SizedBox(height: 24),
            
            // Assignment Overview Section
            _buildAssignmentOverviewSection(),
            const SizedBox(height: 24),
            
            // Question-wise Performance Section
            _buildQuestionWisePerformanceSection(),
            const SizedBox(height: 24),
            
            // Performance Analysis Section
            _buildPerformanceAnalysisSection(),
            const SizedBox(height: 24),
            
            // Recommendations Section
            _buildRecommendationsSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange[100],
            child: Text(
              student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Roll No: ${student.rollNo}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  student.email,
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
    );
  }

  Widget _buildAssignmentOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assignment Overview',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildOverviewCard(
              title: 'Total Score',
              value: '85/100',
              subtitle: '85% - Grade A',
              icon: Icons.grade,
              color: Colors.green,
            ),
            _buildOverviewCard(
              title: 'Time Taken',
              value: '45 min',
              subtitle: 'Out of 60 min',
              icon: Icons.timer,
              color: Colors.blue,
            ),
            _buildOverviewCard(
              title: 'Submission',
              value: 'Jan 15',
              subtitle: '2025 at 2:30 PM',
              icon: Icons.calendar_today,
              color: Colors.purple,
            ),
            _buildOverviewCard(
              title: 'Class Rank',
              value: '#3',
              subtitle: 'Out of 45',
              icon: Icons.emoji_events,
              color: Colors.orange,
            ),
          ],
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
            fontSize: 18,
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
            _buildQuestionTile('Q1', 'Newton\'s First Law', 'Correct', '5/5', Colors.green),
            _buildQuestionTile('Q2', 'Force and Acceleration', 'Correct', '5/5', Colors.green),
            _buildQuestionTile('Q3', 'Momentum Conservation', 'Wrong', '0/5', Colors.red),
            _buildQuestionTile('Q4', 'Work and Energy', 'Correct', '5/5', Colors.green),
            _buildQuestionTile('Q5', 'Gravitational Force', 'Wrong', '0/5', Colors.red),
          ],
        ),
        const SizedBox(height: 16),
        
        // MSQ Section
        _buildQuestionTypeSection(
          'Multiple Select Questions (MSQ)',
          '2/3 Correct',
          Colors.green,
          [
            _buildQuestionTile('Q6', 'Types of Forces', 'Partial', '3/5', Colors.orange),
            _buildQuestionTile('Q7', 'Energy Conservation', 'Correct', '5/5', Colors.green),
            _buildQuestionTile('Q8', 'Motion in 2D', 'Correct', '5/5', Colors.green),
          ],
        ),
        const SizedBox(height: 16),
        
        // NAT Section
        _buildQuestionTypeSection(
          'Numerical Answer Type (NAT)',
          '2/2 Correct',
          Colors.orange,
          [
            _buildQuestionTile('Q9', 'Calculate Velocity', 'Correct', '10/10', Colors.green),
            _buildQuestionTile('Q10', 'Find Acceleration', 'Correct', '10/10', Colors.green),
          ],
        ),
        const SizedBox(height: 16),
        
        // Subjective Section
        _buildQuestionTypeSection(
          'Subjective Questions',
          '1/2 Questions',
          Colors.purple,
          [
            _buildQuestionTile('Q11', 'Explain Newton\'s Laws', 'Good', '7/10', Colors.green),
            _buildQuestionTile('Q12', 'Derive Kinematic Equation', 'Needs Work', '3/10', Colors.orange),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
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
        const SizedBox(height: 16),
        _buildAnalysisCard(
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisCard(
          'Next Steps',
          [
            'Review momentum conservation principles',
            'Practice more multiple select questions',
            'Focus on mathematical derivation techniques',
            'Work on step-by-step problem solving',
            'Schedule regular practice sessions'
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTypeSection(String title, String summary, Color color, List<Widget> questions) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.quiz, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
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
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: questions),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(String questionNo, String question, String status, String score, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                questionNo,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      score,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, List<String> items, Color color, IconData icon) {
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
              Icon(icon, color: color, size: 20),
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
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
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
                      fontSize: 12,
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
