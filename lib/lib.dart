export 'package:firebase_core/firebase_core.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:flutter/material.dart';
export 'common/widgets/global_repo_bloc_provider.dart';
export 'package:responsive_framework/responsive_framework.dart';
export 'package:flutter_web_plugins/url_strategy.dart';
export 'package:lumen_slate/router/router.dart';
export 'constants/app_constants.dart';
export 'firebase_options.dart';

// Services

export 'package:lumen_slate/services/google_auth_services.dart';
export 'package:lumen_slate/services/phone_auth_services.dart';

// Repositories
export 'package:lumen_slate/repositories/ai/context_generator.dart';
export 'package:lumen_slate/repositories/ai/variation_generator.dart';
export 'package:lumen_slate/repositories/mcq_repository.dart';
export 'package:lumen_slate/repositories/msq_repository.dart';
export 'package:lumen_slate/repositories/teacher_repository.dart';

// Blocs
export 'blocs/auth/auth_bloc.dart';
export 'blocs/context_generation/context_generation_bloc.dart';
export 'blocs/mcq/mcq_bloc.dart';
export 'blocs/mcq_variation_generation/mcq_variation_bloc.dart';
export 'blocs/msq/msq_bloc.dart';
export 'blocs/msq_variation_generation/msq_variation_bloc.dart';

// Cubits
export 'cubit/phone_form/phone_number_form_cubit.dart';
