import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';

class ProfilePageDesktop extends StatelessWidget {
  const ProfilePageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile', style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.w500, color: Colors.black)),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthSignedInAsTeacher) {
                  return Card(
                    color: Colors.grey.shade100,
                    elevation: 4,
                    margin: const EdgeInsets.all(32),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: state.user.photoUrl == null
                                ? const Icon(Icons.person, size: 60)
                                : ClipOval(child: Image.network(state.user.photoUrl!, fit: BoxFit.fill)),
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
          ],
        ),
      ),
    );
  }
}
