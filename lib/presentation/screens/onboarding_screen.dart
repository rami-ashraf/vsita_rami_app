
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(height: 40),
              Image.asset("assets/images/Front_logo.png"),
               SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background logo
                  Image.asset("assets/images/background_logo.png"),
                  // Foreground doctor picture
                  Image.asset(
                    "assets/images/doctor_picture.png",
                    width: 443,
                    height: 443.07,
                  ),
                  // Linear Effect with Text
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image.asset("assets/images/Linear_Effect.png"),
                          // Text positioned at bottom of linear effect
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0), // Adjust this value as needed
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Best Doctor",
                                  style: TextStyle(
                                    color: Color.fromRGBO(36, 124, 255, 1),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Appointment App",
                                  style: TextStyle(
                                    color: Color.fromRGBO(36, 124, 255, 1),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 5),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Manage and schedule all of your medical"
                    " appointments easily with Docdoc "
                    "to get a new experience.",
                    textAlign: TextAlign.center
                    ,style:
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(117, 117, 117, 1),
                  )
                  ,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(36, 124, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
            
                      child: Center(
                          child: Text("Get Started",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
            
                          ))),
                ),
              ),
            
              // Login Button
            
            ],
          ),
        ),
      ),
    );
  }
}