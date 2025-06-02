import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalRepoBlocProvider extends StatelessWidget {
  final Widget child;
  final List<RepositoryProvider> repositoryProviders;
  final List<BlocProvider> blocProviders;

  const GlobalRepoBlocProvider({
    super.key,
    required this.child,
    required this.repositoryProviders,
    required this.blocProviders,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: MultiBlocProvider(providers: blocProviders, child: child),
    );
  }
}
