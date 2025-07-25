import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/students.dart';
import '../../../../serializers/agent_serializers/report_card_agent.dart';

class StudentReportPopupMobile extends StatelessWidget {
  final Student student;
  final String classroomId;

  const StudentReportPopupMobile({
    super.key,
    required this.student,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Report',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              student.name,
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
            
            // Overall Performance Section
            _buildOverallPerformanceSection(),
            const SizedBox(height: 24),
            
            // Subject Performance Section
            _buildSubjectPerformanceSection(),
            const SizedBox(height: 24),
            
            // Recent Assignments Section
            _buildRecentAssignmentsSection(),
            const SizedBox(height: 24),
            
            // Insights and Recommendations Section
            _buildInsightsSection(),
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
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue[100],
            child: Text(
              student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
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

  Widget _buildOverallPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Performance',
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
          childAspectRatio: 1.2,
          children: [
            _buildPerformanceCard(
              title: 'Overall Score',
              value: '85%',
              subtitle: 'Excellent',
              icon: Icons.trending_up,
              color: Colors.green,
            ),
            _buildPerformanceCard(
              title: 'Assignments',
              value: '12/15',
              subtitle: '3 pending',
              icon: Icons.assignment_turned_in,
              color: Colors.orange,
            ),
            _buildPerformanceCard(
              title: 'Class Rank',
              value: '#3',
              subtitle: 'Out of 45',
              icon: Icons.emoji_events,
              color: Colors.purple,
            ),
            _buildPerformanceCard(
              title: 'Attendance',
              value: '92%',
              subtitle: 'Above avg',
              icon: Icons.calendar_today,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject Performance',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildSubjectRow('Mathematics', 92, Colors.blue),
              const SizedBox(height: 16),
              _buildSubjectRow('Physics', 85, Colors.green),
              const SizedBox(height: 16),
              _buildSubjectRow('Chemistry', 78, Colors.orange),
              const SizedBox(height: 16),
              _buildSubjectRow('Biology', 88, Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAssignmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Assignments',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildAssignmentTile('Physics Assignment #1', '85/100', 'Jan 15, 2025', Colors.green),
              const Divider(height: 1),
              _buildAssignmentTile('Math Quiz #3', '92/100', 'Jan 12, 2025', Colors.green),
              const Divider(height: 1),
              _buildAssignmentTile('Chemistry Lab Report', '78/100', 'Jan 10, 2025', Colors.green),
              const Divider(height: 1),
              _buildAssignmentTile('Biology Assignment #2', 'Pending', 'Due: Jan 20, 2025', Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights & Recommendations',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Strengths',
          [
            'Excellent problem-solving skills',
            'Strong mathematical foundation',
            'Consistent assignment submission',
            'Active class participation'
          ],
          Colors.green,
          Icons.star,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Areas for Improvement',
          [
            'Time management in exams',
            'Physics conceptual understanding',
            'Lab report writing skills',
            'Group collaboration'
          ],
          Colors.orange,
          Icons.trending_up,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Recommendations',
          [
            'Practice more physics problems',
            'Join study groups for chemistry',
            'Use time management techniques',
            'Seek help during office hours'
          ],
          Colors.blue,
          Icons.lightbulb,
        ),
      ],
    );
  }

  Widget _buildPerformanceCard({
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
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
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

  Widget _buildSubjectRow(String subject, int score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$score%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildAssignmentTile(String title, String score, String date, Color statusColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        date,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          score,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, List<String> items, Color color, IconData icon) {
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
