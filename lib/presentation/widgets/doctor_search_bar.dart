import 'package:flutter/material.dart';

class DoctorSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap; // <-- Add this

  const DoctorSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: onFilterTap, // <-- Use the callback
          child: const Icon(Icons.filter_list),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
