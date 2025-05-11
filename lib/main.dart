import 'package:doctor_new_project/presentation/screens/bookAppointment_screen.dart';
import 'package:doctor_new_project/presentation/screens/doctorsDetails_screen.dart';
import 'package:doctor_new_project/presentation/screens/home_screen.dart';
import 'package:doctor_new_project/presentation/screens/login_screen.dart';
import 'package:doctor_new_project/presentation/screens/myAppointment_scree.dart';
import 'package:doctor_new_project/presentation/screens/recommendation%20Doctor.dart';
import 'package:doctor_new_project/presentation/screens/search_screen.dart';
import 'package:doctor_new_project/presentation/screens/splash_screen.dart';
import 'package:doctor_new_project/presentation/screens/updateUser_screen.dart';
import 'package:doctor_new_project/presentation/screens/userProfile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/appointment_cubit/appointment_cubit.dart';
import 'logic/doctors_cubit/doctors_cubit.dart';
import 'logic/logout_cubit/logout_cubit.dart';
import 'logic/userProfile_cubit/userdata_cubit.dart';
import 'logic/userUpdate_cubit/userUpdate_cubit.dart'; // Import your LogoutCubit

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserProfileCubit>(create: (_) => UserProfileCubit()..getUserProfile()),
        BlocProvider<DoctorsCubit>(create: (_) => DoctorsCubit()..getDoctors()),
        BlocProvider<LogoutCubit>(create: (_) => LogoutCubit()),
        BlocProvider(create: (context) => UserProfileCubit()),
        BlocProvider(create: (context) => UserUpdateCubit()),
        BlocProvider<BookingCubit>(create: (context) => BookingCubit()),
      ],
      child: MaterialApp(
        title: 'DocDoc',
        debugShowCheckedModeBanner: false,
        // Define routes here
        routes: {
          '/home': (context) =>  HomeScreen(),
          '/search': (context) =>  RecommendationDoctor(),
          '/appointments': (context) =>  MyAppointmentsScreen(),
          '/profile': (context) =>  UserProfileScreen(),
        },
        // Set initial route here (e.g., SplashScreen or HomeScreen)
        //initialRoute: '/home',
        home: SplashScreen(),
      ),
    );
  }
}
