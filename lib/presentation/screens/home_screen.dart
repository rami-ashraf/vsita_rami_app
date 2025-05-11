import 'package:doctor_new_project/presentation/screens/recommendation%20Doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation_bar.dart';
import '../../logic/doctors_cubit/doctors_cubit.dart';
import '../../logic/doctors_cubit/doctors_states.dart';
import '../../logic/userProfile_cubit/userData_states.dart';
import '../../logic/userProfile_cubit/userdata_cubit.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'doctorsDetails_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().getUserProfile(); //
    context.read<DoctorsCubit>().getDoctors(); //
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileStates>(
      builder: (context, state) {
        if (state is UserProfileLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is UserProfileErrorState) {
          return Scaffold(
            body: Center(child: Text(state.error)),
          );
        }

        if (state is UserProfileSucessState) {
          final userData = context.read<UserProfileCubit>().cachedUserData;

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${userData?.name.split(' ').first ?? 'User'}!",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(36, 36, 36, 1),
                            ),
                          ),
                          const Text(
                            "How are you today?",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(97, 97, 97, 1),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.notifications),
                      const SizedBox(height: 15),
                      const CustomPopupMenu(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Image.asset("assets/images/book_and_schedule.png"),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Doctor Speciality",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(36, 36, 36, 1),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(36, 124, 255, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Image.asset("assets/images/General_doctor_speciality.png", width: 73.75, height: 86),
                      const Spacer(),
                      Image.asset("assets/images/Neurologic (1).png", width: 73.75, height: 86),
                      const Spacer(),
                      Image.asset("assets/images/Pediatric.png", width: 73.75, height: 86),
                      const Spacer(),
                      Image.asset("assets/images/Radiology.png", width: 73.75, height: 86),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Recommendation Doctor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(36, 36, 36, 1),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RecommendationDoctor()),
                          );
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(36, 124, 255, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 500,
                    child: BlocBuilder<DoctorsCubit, DoctorsStates>(
                      builder: (context, state) {
                        if (state is DoctorsLoadingStates) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is DoctorsErrorStates) {
                          return Center(child: Text(state.message));
                        } else if (state is DoctorsSuccessStates) {
                          final doctors = state.doctors;
                          return ListView.builder(
                            itemCount: doctors.length > 8 ? 8 : doctors.length,
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
            bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              elevation: 4,
              child: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        }

        //  initial
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
