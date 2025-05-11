import 'package:doctor_new_project/presentation/screens/updateUser_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation_bar.dart';
import '../../core/rounded_back_button.dart';
import '../../logic/userProfile_cubit/userData_states.dart';
import '../../logic/userProfile_cubit/userdata_cubit.dart';


class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileStates>(
      builder: (context, state) {
        // Handle different states
        if (state is UserProfileLoadingState) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is UserProfileErrorState) {
          return Scaffold(body: Center(child: Text(state.error)));
        }
        if (state is UserProfileSucessState) {
          final user = context.read<UserProfileCubit>().cachedUserData;
          final avatarSize = 120.0;
          final avatarTopPosition = 160.0; // Positions avatar half in blue

          return Scaffold(
            body: Column(
              children: [
                // Blue header section
                Container(
                  height: 200,
                  color: const Color(0xFF0B5FFF),
                  child: Stack(
                    children: [
                      // App bar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: RoundedBackButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          iconColor: Colors.white,),
                          title: const Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          centerTitle: true,

                          actions: [
                            CustomPopupMenu(
                            ), // Your popup menu

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // White content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile picture positioned to overlap
                        Transform.translate(
                          offset: const Offset(0, -60), // Half of avatar size
                          child: Center(
                            child: Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/userphoto.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // User information - all below the profile picture
                        Padding(
                          padding: const EdgeInsets.only(top: 10), // Space below avatar
                          child: Column(
                            children: [
                              Text(
                                user?.name ?? "No Name",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user?.email ?? "noemail@example.com",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildProfileItem(Icons.account_circle_outlined, "Gender", user?.gender ?? "-"),
                              _buildProfileItem(Icons.phone, "Phone", user?.phone ?? "-"),
                              _buildProfileItem(Icons.mail_outline, "Email", user?.email ?? "-"),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateUserScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Your Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text("Unknown state")));
      },
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}