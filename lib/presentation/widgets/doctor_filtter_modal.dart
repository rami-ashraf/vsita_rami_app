import 'package:flutter/material.dart';
import '../../data/doctorData.dart';

class DoctorFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  final List<DoctorsData> allDoctors;

  const DoctorFilterModal({
    super.key,
    required this.onApply,
    required this.allDoctors,
  });

  @override
  State<DoctorFilterModal> createState() => _DoctorFilterModalState();
}

class _DoctorFilterModalState extends State<DoctorFilterModal> {
  String? degree;
  String? specialization;
  String? city;

  @override
  Widget build(BuildContext context) {
    final degrees = widget.allDoctors.map((e) => e.degree).toSet().toList();
    final specializations = widget.allDoctors.map((e) => e.specialization.name).toSet().toList();
    final cities = widget.allDoctors.map((e) => e.city.name).toSet().toList();

    return AlertDialog(
      title: const Text('Filter Doctors'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: degree,
              items: degrees.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => degree = val),
              decoration: const InputDecoration(labelText: 'Degree'),
            ),
            DropdownButtonFormField<String>(
              value: specialization,
              items: specializations.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => specialization = val),
              decoration: const InputDecoration(labelText: 'Specialization'),
            ),
            DropdownButtonFormField<String>(
              value: city,
              items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => city = val),
              decoration: const InputDecoration(labelText: 'City'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final filters = {
              'degree': degree,
              'specialization': specialization,
              'city': city,
            };
            widget.onApply(filters);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
