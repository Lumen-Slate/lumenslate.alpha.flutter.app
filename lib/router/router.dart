import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen_slate/pages/sign_in_page/choose_role_page.dart';

import '../pages/add_question_page/add_question_page.dart';
import '../pages/assignments_page/assignment_detail_page.dart';
import '../pages/assignments_page/assignments_page.dart';
import '../pages/chat_agent_page/chat_agent_page.dart';
import '../pages/classrooms_page/classrooms.dart';
import '../pages/loading_page/loading.dart';
import '../pages/profile_page/profile_page.dart';
import '../pages/question_bank_page/question_bank.dart';
import '../pages/questions_page/questions.dart';
import '../pages/rag_agent_page/rag_agent_page.dart';
import '../pages/sign_in_page/sign_in_page.dart';
import '../pages/pdf_generator_page/pdf_generator_page.dart';
import '../pages/students_page/students.dart';
import '../pages/student_detail_page/student_detail.dart';
import '../pages/teacher_dashboard_page/teacher_dashboard.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: LoadingPage()),
    ),
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) => const MaterialPage(child: SignInPage()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => MaterialPage(child: ProfilePage()),
    ),
    GoRoute(
      path: '/choose-role',
      pageBuilder: (context, state) => const MaterialPage(child: ChooseRolePage()),
    ),
    GoRoute(
      path: '/student-dashboard',
      pageBuilder: (context, state) => MaterialPage(child: Placeholder()),
    ),
    GoRoute(
      path: '/teacher-dashboard',
      pageBuilder: (context, state) => MaterialPage(child: TeacherDashboardPage()),
      routes: [
        GoRoute(
          path: '/question-banks',
          pageBuilder: (context, state) => MaterialPage(child: QuestionBankPage()),
        ),
        GoRoute(
          path: '/questions',
          pageBuilder: (context, state) {
            final bankId = state.uri.queryParameters['bank'];
            return MaterialPage(child: Questions(bankId: bankId));
          },
        ),
        GoRoute(
          path: '/classrooms',
          pageBuilder: (context, state) => MaterialPage(child: ClassroomsPage()),
          routes: [
            GoRoute(
              path: '/:classroomId/students',
              pageBuilder: (context, state) {
                final classroomId = state.pathParameters['classroomId'];
                return MaterialPage(child: StudentsPage(classroomId: classroomId!));
              },
              routes: [
                GoRoute(
                  path: '/:studentId',
                  pageBuilder: (context, state) {
                    final classroomId = state.pathParameters['classroomId'];
                    final studentId = state.pathParameters['studentId'];
                    return MaterialPage(
                      child: StudentDetailPage(studentId: studentId!, classroomId: classroomId!),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/assignments',
          pageBuilder: (context, state) => MaterialPage(child: AssignmentsPage()),
          routes: [
            GoRoute(
              path: '/:assignmentId',
              pageBuilder: (context, state) {
                final assignmentId = state.pathParameters['assignmentId'];
                return MaterialPage(child: AssignmentDetailPage(assignmentId: assignmentId!));
              },
            ),
          ],
        ),
        GoRoute(
          path: '/pdf-generator',
          pageBuilder: (context, state) => MaterialPage(child: PdfGeneratorPage()),
        ),
        GoRoute(
          path: '/agent',
          pageBuilder: (context, state) => MaterialPage(child: ChatAgentPage()),
        ),
        GoRoute(
          path: '/rag-agent',
          pageBuilder: (context, state) => MaterialPage(child: RagAgentPage()),
        ),
      ],
    ),
    GoRoute(
      path: '/add-question',
      pageBuilder: (context, state) => MaterialPage(child: AddQuestion()),
    ),
  ],
);
