import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat screen not implemented yet')),
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/search');
        break;
      case 3:
        Navigator.pushNamed(context, '/appointments');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(context, Icons.home_outlined, 0),
            _buildMessageItem(context),
            const SizedBox(width: 40), // Space for FAB
            _buildNavItem(context, Icons.calendar_today_outlined, 3),
            _buildNavItem(context, Icons.person_outline, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
      onPressed: () => _onItemTapped(context, index),
    );
  }

  Widget _buildMessageItem(BuildContext context) {
    bool isActive = currentIndex == 1;
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          onPressed: () => _onItemTapped(context, 1),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
