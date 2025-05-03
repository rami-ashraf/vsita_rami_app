import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/home_cubit/home_cubit.dart';
import '../../logic/home_cubit/home_state.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getUserProfile(),
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is HomeErrorState) {
            return Scaffold(
              body: Center(child: Text(state.error)),
            );
          }

          if (state is HomeSucessState) {
            final userData = context.read<HomeCubit>().cachedUserData;

            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
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
                    ],
                  ),
                ),
              ),
            );
          }

          // Fallback (shouldn't reach here ideally)
          return const Scaffold(
            body: Center(child: Text("Unknown state")),
          );
        },
      ),
    );
  }
}
