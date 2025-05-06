import 'package:flutter/material.dart';
import '../../core/rounded_back_button.dart';
import '../../data/doctorData.dart';
import 'home_screen.dart';

class DoctorsDetails extends StatelessWidget {
  final DoctorsData doctor;

  const DoctorsDetails({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(36, 36, 36, 1),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('${doctor.degree} - ${doctor.specialization.name}'),
                        Text('${doctor.city.name}, ${doctor.city.governrate.name}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: "About"),
                  Tab(text: "Location"),
                  Tab(text: "Reviews"),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("About me", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(doctor.description ?? 'No description available.'),
                          const SizedBox(height: 16),


                          const SizedBox(height: 16),
                          const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(doctor.gender ?? 'No Gender available.'),

                          const SizedBox(height: 16),
                          const Text("Phone number", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(doctor.phone ?? 'No phone number available.'),


                          const SizedBox(height: 16),
                          const Text("Email address", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(doctor.email ?? 'No email address available.'),


                          const SizedBox(height: 16),
                          const Text("Starting time", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(doctor.startTime ?? 'No starting time available.'),



                          const SizedBox(height: 16),
                          const Text("Ending time", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(doctor.endTime ?? 'No Ending time available.'),


                          const SizedBox(height: 16),
                          const Text("Appointment price", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(doctor.appointPrice.toString()+' EGP' ?? 'No appointment price available.'),



                        ],
                      ),
                    ),
                    Center(
                      child: Text("Address : ${doctor.city.name}, ${doctor.city.governrate.name}"),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 50),
                          SizedBox(height: 10),
                          Text("4.8 (4,279 reviews)", style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Text("More reviews coming soon..."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle appointment logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Make An Appointment", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}