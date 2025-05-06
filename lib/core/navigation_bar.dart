import 'package:flutter/material.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/recommendation Doctor.dart';
import '../presentation/screens/userProfile_screen.dart';

class CustomPopupMenu extends StatelessWidget {
  final BuildContext context; // Pass the context from the calling widget

  const CustomPopupMenu({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'Home') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (value == 'Profile') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UserprofileScreen()));
        }
        else if (value == 'Recommendation Doctor') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RecommendationDoctor()));
        }
        else if (value == 'Logout') {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'Home',
          child: Text('Home'),
        ),
        const PopupMenuItem(
          value: 'Profile',
          child: Text('Profile'),
        ),
        const PopupMenuItem(
          value: 'Recommendation Doctor',
          child: Text('Recommendation Doctor'),
        ),
        const PopupMenuItem(
          value: 'Logout',
          child: Text('Logout'),
        ),
      ],
    );
  }
}