
import 'package:doctor_new_project/presentation/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/login_cubit/login_cubit.dart';
import '../../logic/login_cubit/login_state.dart';
import '../../logic/signup_cubit/signup_cubit.dart';
import 'forgotPassword_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();


  bool secureText = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (BuildContext context,  state) {
          if(state is LoginErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }else if(state is LoginSucessState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Login Success")));
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


                    // welcome message
                    Text("Welcome Back",style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(36, 124, 255, 1),
                    ),),

                    SizedBox(height: 20),

                    // text under welcome message
                    Text("We're excited to have you back, can't wait to see what you've been up to since you last logged in.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),),

                    SizedBox(height: 20),

                    // Email Text Field
                    Form(
                      key: formKey  ,
                      child:
                      Column(
                        children: [
                          TextFormField(
                            controller: emailcontroller,
                            validator: (value){
                              if(value==null||value.isEmpty){
                                return "please enter your email";
                              }
                            },
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
                            validator: (value){
                              if(value==null||value.isEmpty){
                                return "please enter your password";
                              }
                            },
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
                        ],
                      ),
                    ),




                    SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      value: rememberMe, // Use the state variable
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false; // Update state when changed
                        });
                      },
                    ),
                    Text(
                      "Remember Me",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotpasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(36, 124, 255, 1),
                          ),
                        ),
                      ),
                      ],
                    ),


                    SizedBox(height: 40),

                    // Sign  Button
                    InkWell(
                      onTap: () {
                        if(formKey.currentState!.validate()){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fields is required ")));
                        }

                        context.read<LoginCubit>().Login(
                            email: emailcontroller.text,
                            pass: passwordcontroller.text);


                      },
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(36, 124, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: state is LoginLoadingState ? Center(child: CircularProgressIndicator(color: Colors.white,)) :
                          Center(
                              child: Text("Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),

                              ))),
                    ),

                    SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),),
                        TextButton(onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        } , child: Text("Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(36, 124, 255, 1),
                          ),
                          )


                        )],
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
