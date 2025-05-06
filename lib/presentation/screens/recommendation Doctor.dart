import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/rounded_back_button.dart';
import '../../logic/doctors_cubit/doctors_cubit.dart';
import '../../logic/doctors_cubit/doctors_states.dart';
import '../../data/doctorData.dart';
import 'DoctorsDetails_screen.dart';
import 'home_screen.dart';


class RecommendationDoctor extends StatelessWidget {
  const RecommendationDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorsCubit()..getDoctors(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  RoundedBackButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "Recommendation Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(36, 36, 36, 1),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: BlocBuilder<DoctorsCubit, DoctorsStates>(
                  builder: (context, state) {
                    if (state is DoctorsLoadingStates) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorsErrorStates) {
                      return Center(child: Text(state.message));
                    } else if (state is DoctorsSuccessStates) {
                      final doctors = state.doctors;
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
                              leading:                   ClipRRect(
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
