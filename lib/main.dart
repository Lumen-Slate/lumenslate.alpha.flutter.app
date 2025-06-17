import 'package:lumen_slate/repositories/ai/agent_repository.dart';
import 'package:lumen_slate/repositories/classroom_repository.dart';
import 'package:lumen_slate/repositories/assignment_repository.dart';
import 'package:lumen_slate/repositories/question_bank_repository.dart';
import 'blocs/assignment/assignment_bloc.dart';
import 'blocs/chat_agent/chat_agent_bloc.dart';
import 'blocs/classroom/classroom_bloc.dart';
import 'blocs/question_bank/question_bank_bloc.dart';
import 'lib.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LumenSlate());
}

class LumenSlate extends StatelessWidget {
  const LumenSlate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => GoogleAuth()),
        RepositoryProvider(create: (context) => PhoneAuth()),
        RepositoryProvider(create: (context) => AIRepository()),
        RepositoryProvider(create: (context) => VariationRepository()),
        RepositoryProvider(create: (context) => QuestionSegmentationRepository()),
        RepositoryProvider(create: (context) => MCQRepository()),
        RepositoryProvider(create: (context) => MSQRepository()),
        RepositoryProvider(create: (context) => NATRepository()),
        RepositoryProvider(create: (context) => SubjectiveRepository()),
        RepositoryProvider(create: (context) => TeacherRepository()),
        RepositoryProvider(create: (context) => QuestionBankRepository()),
        RepositoryProvider(create: (context) => AgentRepository()),
        RepositoryProvider(create: (context) => ClassroomRepository()),
        RepositoryProvider(create: (context) => AssignmentRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
              googleAuthServices: RepositoryProvider.of<GoogleAuth>(context),
              phoneAuthServices: RepositoryProvider.of<PhoneAuth>(context),
            ),
          ),
          BlocProvider(create: (context) => PhoneNumberFormCubit()),
          BlocProvider(
            create: (context) => ContextGeneratorBloc(
              RepositoryProvider.of<AIRepository>(context),
              RepositoryProvider.of<MCQRepository>(context),
              RepositoryProvider.of<MSQRepository>(context),
              RepositoryProvider.of<NATRepository>(context),
              RepositoryProvider.of<SubjectiveRepository>(context),
            ),
          ),
          BlocProvider(create: (context) => MCQVariationBloc(RepositoryProvider.of<VariationRepository>(context))),
          BlocProvider(create: (context) => MSQVariationBloc(RepositoryProvider.of<VariationRepository>(context))),
          BlocProvider(
            create: (context) =>
                QuestionSegmentationBloc(RepositoryProvider.of<QuestionSegmentationRepository>(context)),
          ),
          BlocProvider(create: (context) => MCQBloc(RepositoryProvider.of<MCQRepository>(context))),
          BlocProvider(create: (context) => MSQBloc(RepositoryProvider.of<MSQRepository>(context))),
          BlocProvider(
            create: (context) => QuestionsBloc(
              mcqRepository: RepositoryProvider.of<MCQRepository>(context),
              msqRepository: RepositoryProvider.of<MSQRepository>(context),
              natRepository: RepositoryProvider.of<NATRepository>(context),
              subjectiveRepository: RepositoryProvider.of<SubjectiveRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => QuestionBankBloc(repository: RepositoryProvider.of<QuestionBankRepository>(context)),
          ),
          BlocProvider(create: (context) => ChatAgentBloc(repository: RepositoryProvider.of<AgentRepository>(context))),
          BlocProvider(
            create: (context) =>
                ClassroomBloc(classroomRepository: RepositoryProvider.of<ClassroomRepository>(context)),
          ),
          BlocProvider(
            create: (context) => AssignmentBloc(repository: RepositoryProvider.of<AssignmentRepository>(context)),
          ),
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
          routerConfig: router,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
        ),
      ),
    );
  }
}
