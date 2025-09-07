import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';

class ProfilePageDesktop extends StatelessWidget {
  const ProfilePageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSignedInAsTeacher) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: state.user.photoUrl == null ? const Icon(Icons.person, size: 60) : null,
                      ),
                      const SizedBox(height: 24),
                      Text(state.user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(state.user.email, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                        onPressed: () {
                          context.read<AuthBloc>().add(SignOut());
                          context.go('/');
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is Loading) {
              return const CircularProgressIndicator();
            } else if (state is AuthFailure) {
              return Text('Error: ${state.message}');
            } else {
              return const Text('No user data available.');
            }
          },
        ),
      ),
    );
  }
}
