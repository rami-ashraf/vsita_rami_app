import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation_bar.dart';
import '../../core/rounded_back_button.dart';
import '../../data/doctorData.dart';
import '../../logic/doctors_cubit/doctors_cubit.dart';
import '../../logic/doctors_cubit/doctors_states.dart';
import '../widgets/doctor_filtter_modal.dart';
import '../widgets/doctor_search_bar.dart';
import 'doctorsDetails_screen.dart';

class RecommendationDoctor extends StatefulWidget {
  const RecommendationDoctor({super.key});

  @override
  State<RecommendationDoctor> createState() => _RecommendationDoctorState();
}

class _RecommendationDoctorState extends State<RecommendationDoctor> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};

  void _showFilterModal(List<DoctorsData> doctors) {
    showDialog(
      context: context,
      builder: (_) => DoctorFilterModal(
        allDoctors: doctors,
        onApply: (filters) {
          setState(() {
            _filters = filters;
          });
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorsCubit()..getDoctors(),
      child: Scaffold(
        appBar: AppBar(
          leading: RoundedBackButton(onPressed: () => Navigator.pop(context)),
          title: const Text(
            "Recommendation Doctor",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(36, 36, 36, 1),
            ),
          ),
          actions: [CustomPopupMenu()],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              DoctorSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                onFilterTap: () {
                  if (context.read<DoctorsCubit>().state is DoctorsSuccessStates) {
                    final doctors = (context.read<DoctorsCubit>().state as DoctorsSuccessStates).doctors;
                    _showFilterModal(doctors);
                  }
                },

              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<DoctorsCubit, DoctorsStates>(
                  builder: (context, state) {
                    if (state is DoctorsLoadingStates) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorsErrorStates) {
                      return Center(child: Text(state.message));
                    } else if (state is DoctorsSuccessStates) {
                      final doctors = state.doctors.where((doctor) {
                        final query = _searchQuery;

                        bool matchesSearch = doctor.name.toLowerCase().contains(query) ||
                            doctor.degree.toLowerCase().contains(query) ||
                            doctor.specialization.name.toLowerCase().contains(query) ||
                            doctor.city.name.toLowerCase().contains(query) ||
                            doctor.city.governrate.name.toLowerCase().contains(query);

                        bool matchesFilter = true;

                        if (_filters['gender'] != null && doctor.gender != _filters['gender']) matchesFilter = false;

                        if (_filters['description'] != null &&
                            !doctor.description.toLowerCase().contains(
                              _filters['description'].toString().toLowerCase(),
                            )) matchesFilter = false;

                        if (_filters['degree'] != null &&
                            !doctor.degree.toLowerCase().contains(
                              _filters['degree'].toString().toLowerCase(),
                            )) matchesFilter = false;

                        if (_filters['specialization'] != null &&
                            !doctor.specialization.name.toLowerCase().contains(
                              _filters['specialization'].toString().toLowerCase(),
                            )) matchesFilter = false;

                        if (_filters['city'] != null &&
                            !doctor.city.name.toLowerCase().contains(
                              _filters['city'].toString().toLowerCase(),
                            )) matchesFilter = false;

                        if (_filters['appointPrice'] != null &&
                            doctor.appointPrice > _filters['appointPrice']) matchesFilter = false;

                        if (_filters['startTime'] != null) {
                          final doctorStart = TimeOfDay(
                            hour: int.tryParse(doctor.startTime.split(":")[0]) ?? 0,
                            minute: int.tryParse(doctor.startTime.split(":")[1]) ?? 0,
                          );
                          if (doctorStart.hour < _filters['startTime'].hour) matchesFilter = false;
                        }

                        if (_filters['endTime'] != null) {
                          final doctorEnd = TimeOfDay(
                            hour: int.tryParse(doctor.endTime.split(":")[0]) ?? 0,
                            minute: int.tryParse(doctor.endTime.split(":")[1]) ?? 0,
                          );
                          if (doctorEnd.hour > _filters['endTime'].hour) matchesFilter = false;
                        }

                        return matchesSearch && matchesFilter;
                      }).toList();

                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  doctor.photo,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/doctor_avatar.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                doctor.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${doctor.degree} - ${doctor.specialization.name}'),
                                  const SizedBox(height: 4),
                                  Text('${doctor.city.name}, ${doctor.city.governrate.name}'),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.price_check, size: 20),
                                  Text('EGP ${doctor.appointPrice}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorsDetails(doctor: doctor),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
