import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';

class ProfilePageMobile extends StatelessWidget {
  const ProfilePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  CircleAvatar(
                    radius: 50,
                    child: state.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              state.photoUrl!,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50),
                            ),
                          )
                        : const Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(state.email, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOut());
                      Navigator.of(context).pushReplacementNamed('/sign_in');
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            } else if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No user data available.'));
            }
          },
        ),
      ),
    );
  }
}
