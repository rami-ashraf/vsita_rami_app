

import 'package:doctor_new_project/presentation/screens/doctorsDetails_screen.dart';
import 'package:doctor_new_project/presentation/screens/home_screen.dart';
import 'package:doctor_new_project/presentation/screens/login_screen.dart';
import 'package:doctor_new_project/presentation/screens/recommendation%20Doctor.dart';
import 'package:doctor_new_project/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/doctors_cubit/doctors_cubit.dart';
import 'logic/home_cubit/home_cubit.dart';




void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit()..getUserProfile(),
        ),
        BlocProvider<DoctorsCubit>(
          create: (_) => DoctorsCubit()..getDoctors(),
        ),
      ],
      child: MaterialApp(
        title: 'doctor_app_rami',
        //home: SplashScreen() ,
        //home: HomeScreen() ,
        //home: LoginScreen() ,
        home: RecommendationDoctor() ,
        debugShowCheckedModeBanner: false,

      ),
    );
  }
}
