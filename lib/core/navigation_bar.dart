import 'package:doctor_new_project/presentation/screens/userProfile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/logout_cubit/logout_cubit.dart';
import '../logic/logout_cubit/logout_states.dart';

import '../logic/doctors_cubit/doctors_cubit.dart';
import '../logic/userProfile_cubit/userdata_cubit.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/recommendation Doctor.dart';


class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, logoutStates>(
      listener: (context, state) {
        if (state is logoutSuccessState) {
          // Reset application state
          _resetApplicationState(context);

          // Navigate to login screen and clear all routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  LoginScreen()),
                (route) => false,
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is logoutErrorState) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.black87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        onSelected: (value) => _handleMenuSelection(context, value),
        itemBuilder: (BuildContext context) => [
          _buildMenuItem(
            icon: Icons.home,
            label: 'Home',
            value: 'Home',
          ),
          _buildMenuItem(
            icon: Icons.person,
            label: 'Profile',
            value: 'Profile',
          ),
          _buildMenuItem(
            icon: Icons.medical_services,
            label: 'Recommend Doctor',
            value: 'Recommendation Doctor',
          ),
          const PopupMenuDivider(height: 1),
          _buildMenuItem(
            icon: Icons.logout,
            label: 'Logout',
            value: 'Logout',
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // Helper method to build menu items with consistent styling
  PopupMenuItem<String> _buildMenuItem({
    required IconData icon,
    required String label,
    required String value,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.red : Colors.black87),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isDestructive ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Handle menu item selection
  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'Home':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfileScreen()),
        );
        break;
      case 'Recommendation Doctor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecommendationDoctor()),
        );
        break;
      case 'Logout':
        _showLogoutConfirmation(context);
        break;
    }
  }

  // Reset all cubits/blocs
  void _resetApplicationState(BuildContext context) {
    try {
      context.read<UserProfileCubit>().reset();
    } catch (e) {
      debugPrint('Error resetting HomeCubit: $e');
    }

    try {
      context.read<DoctorsCubit>().reset();
    } catch (e) {
      debugPrint('Error resetting DoctorsCubit: $e');
    }
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<LogoutCubit>().logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}