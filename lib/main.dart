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
    return GlobalRepoBlocProvider(
      repositoryProviders: [
        RepositoryProvider(create: (context) => GoogleAuth()),
        RepositoryProvider(create: (context) => PhoneAuth()),
        RepositoryProvider(create: (context) => AIRepository()),
        RepositoryProvider(create: (context) => VariationRepository()),
        RepositoryProvider(create: (context) => MCQRepository()),
        RepositoryProvider(create: (context) => MSQRepository()),
        RepositoryProvider(create: (context) => TeacherRepository()),
      ],
      blocProviders: [
        BlocProvider(
          create: (context) => AuthBloc(
            teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
            googleAuthServices: RepositoryProvider.of<GoogleAuth>(context),
            phoneAuthServices: RepositoryProvider.of<PhoneAuth>(context),
          ),
        ),
        BlocProvider(create: (context) => PhoneNumberFormCubit()),
        BlocProvider(create: (context) => ContextGeneratorBloc(RepositoryProvider.of<AIRepository>(context))),
        BlocProvider(create: (context) => MCQVariationBloc(RepositoryProvider.of<VariationRepository>(context))),
        BlocProvider(create: (context) => MSQVariationBloc(RepositoryProvider.of<VariationRepository>(context))),
        BlocProvider(create: (context) => MCQBloc(RepositoryProvider.of<MCQRepository>(context))),
        BlocProvider(create: (context) => MSQBloc(RepositoryProvider.of<MSQRepository>(context))),
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
    );
  }
}
