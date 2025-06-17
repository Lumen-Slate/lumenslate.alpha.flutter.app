import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/add_question_page/add_question_page.dart';
import '../pages/assignments_page/assignments.dart';
import '../pages/chat_agent_page/desktop/chat_agent_page.dart';
import '../pages/classrooms_page/classrooms.dart';
import '../pages/dashboard_page/dashboard.dart';
import '../pages/loading_page/loading.dart';
import '../pages/question_bank_page/question_bank.dart';
import '../pages/questions_page/questions.dart';
import '../pages/sign_in_page/sign_in.dart';
import '../pages/pdf_generator_page.dart';

final GoRouter router = GoRouter(
  // initialLocation: '/teacher-dashboard',
  routes: [
    GoRoute(path: '/', pageBuilder: (context, state) => const MaterialPage(child: LoadingPage())),
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) => const MaterialPage(child: SignInDesktop()),
    ),
    GoRoute(
      path: '/teacher-dashboard',
      pageBuilder: (context, state) => MaterialPage(child: DashboardPage()),
      routes: [
        GoRoute(path: '/question-banks', pageBuilder: (context, state) => MaterialPage(child: QuestionBankPage())),
        GoRoute(path: '/questions', pageBuilder: (context, state) => MaterialPage(child: Questions())),
        GoRoute(path: '/classrooms', pageBuilder: (context, state) => MaterialPage(child: ClassroomsPage())),
        GoRoute(path: '/assignments', pageBuilder: (context, state) => MaterialPage(child: AssignmentsPage())),
        GoRoute(path: '/pdf-generator', pageBuilder: (context, state) => MaterialPage(child: PdfGeneratorPage())),
        GoRoute(path: '/agent', pageBuilder: (context, state) => MaterialPage(child: ChatAgentPageDesktop())),
      ],
    ),
    GoRoute(path: '/add-question', pageBuilder: (context, state) => MaterialPage(child: AddQuestion())),
  ],
);
