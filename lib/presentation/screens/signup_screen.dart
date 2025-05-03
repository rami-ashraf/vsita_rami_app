
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/signup_cubit/signup_cubit.dart';
import '../../logic/signup_cubit/signup_state.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
   SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController phonecontroller = TextEditingController();

  TextEditingController namecontroller = TextEditingController();

  TextEditingController gendercontroller = TextEditingController();

  TextEditingController confirmpasswordcontroller = TextEditingController();

   bool secureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit,SignUpStates>(
        listener: (BuildContext context,  state) {
          if(state is SignUpErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }else if(state is SignUpSucessState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" SingUp Success")));
            Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
          }
        },
        builder: (BuildContext context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),

                  Text("Create Account",style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(36, 124, 255, 1),
                  ),),

                  SizedBox(height: 20),

                  Text("Sign up now and start exploring all that our app has to offer. We're excited to welcome you to our community!",
                    style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),),

                  SizedBox(height: 20),

                  // Email Text Field
                  TextFormField(
                    controller: emailcontroller,
                    style: TextStyle(
                      color: Colors.black, // Changed from white to black for better visibility
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(253, 253, 255, 1),
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(194, 194, 194, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when not focused
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when focused
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Password Text Field
                  TextFormField(
                    controller: passwordcontroller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            secureText = !secureText;
                          });
                        },
                        icon: Icon(
                          secureText ? Icons.visibility_off_outlined : Icons.visibility,
                          color: Color.fromRGBO(194, 194, 194, 1),
                        ),
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(253, 253, 255, 1),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(194, 194, 194, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1),
                          width: 4.0,
                        ),
                      ),
                    ),
                    obscureText: secureText,
                  ),


                  SizedBox(height: 20),
                  // Confirm Password Text Field
                  TextFormField(
                    controller: confirmpasswordcontroller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            secureText = !secureText;
                          });
                        },
                        icon: Icon(
                          secureText ? Icons.visibility_off_outlined : Icons.visibility,
                          color: Color.fromRGBO(194, 194, 194, 1),
                        ),
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(253, 253, 255, 1),
                      hintText: "confirm Password",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(194, 194, 194, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1),
                          width: 4.0,
                        ),
                      ),
                    ),
                    obscureText: secureText,
                  ),

                  SizedBox(height: 20),
                  // Gender Text Field
                  TextFormField(
                    controller: gendercontroller,
                    style: TextStyle(
                      color: Colors.black, // Changed from white to black for better visibility
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(253, 253, 255, 1),
                      hintText: "Gender",
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(194, 194, 194, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when not focused
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when focused
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // phone
                  TextFormField(
                    controller: phonecontroller,
                    style: TextStyle(
                      color: Colors.black, // Changed from white to black for better visibility
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(253, 253, 255, 1),
                      hintText: "Your Phone Number",
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(194, 194, 194, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when not focused
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when focused
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // name
                  TextFormField(
                    controller: namecontroller,
                    style: TextStyle(
                      color: Colors.black, // Changed from white to black for better visibility
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(253, 253, 255, 1),
                      hintText: "name",
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(194, 194, 194, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when not focused
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(237, 237, 237, 1), // Border color when focused
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Create Account Button
                  InkWell(
                    onTap: () {
                      context.read<SignUpCubit>().signUp(
                          email: emailcontroller.text,
                          name: namecontroller.text,
                          gender: gendercontroller.text,
                          phone: phonecontroller.text,
                          pass: passwordcontroller.text,
                          confirmationPass: confirmpasswordcontroller.text);

                    },
                    child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(36, 124, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Center(
                            child: Text("Create Account",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),

                            ))),
                  ),





                ],

              ),
            ),
          ),


        );},
      ),
    );
  }
}
