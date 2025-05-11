import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation_bar.dart';
import '../../core/rounded_back_button.dart';
import '../../logic/myAppointment_cubit/myAppointment_cubit.dart';
import '../../logic/myAppointment_cubit/myAppointment_states.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyAppointmentCubit()..getMyAppointments(),
      child: Scaffold(
        appBar: AppBar(
          leading: RoundedBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "My Appointment",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(36, 36, 36, 1),
            ),
          ),
          actions: [
            CustomPopupMenu(), // Your popup menu
          ],
        ),
        body: const AppointmentTabs(),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 4,
          child: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class AppointmentTabs extends StatefulWidget {
  const AppointmentTabs({super.key});

  @override
  State<AppointmentTabs> createState() => _AppointmentTabsState();
}

class _AppointmentTabsState extends State<AppointmentTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final tabs = const ['Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const AppointmentList(status: 'upcoming'),
              Container(child: Center(child: Text("No Completed Yet"))),
              Container(child: Center(child: Text("No Cancelled Yet"))),
            ],
          ),
        ),
      ],
    );
  }
}

class AppointmentList extends StatelessWidget {
  final String status;
  const AppointmentList({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAppointmentCubit, MyAppointmentStates>(
      builder: (context, state) {
        if (state is MyAppointmentLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MyAppointmentErrorState) {
          return Center(child: Text(state.error));
        } else if (state is MyAppointmentSucessState) {
          final appointments =
              context.read<MyAppointmentCubit>().appointmentsList;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/doctor_avatar.png',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        appointment.doctor.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),

                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.doctor.specialization.name,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.appointmentTime,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                alignment: Alignment.center,

                              ),
                              child: const Text(
                                'Cancel Appointment',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reschedule'),
                            ),
                          ),
                        ],
                      )


                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
