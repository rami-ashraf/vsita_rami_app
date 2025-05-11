import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation_bar.dart';
import '../../core/rounded_back_button.dart';
import '../../data/userData.dart';
import '../../logic/userProfile_cubit/userdata_cubit.dart';
import '../../logic/userProfile_cubit/userData_states.dart';
import '../../logic/userUpdate_cubit/userUpdate_cubit.dart';
import '../../logic/userUpdate_cubit/userUpdate_states.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  UserData? _currentUserData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _genderController = TextEditingController();

    _currentUserData = UserData(
      name: '',
      email: '',
      phone: '',
      gender: '',
    );

    context.read<UserProfileCubit>().getUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<UserProfileCubit>();
    if (cubit.cachedUserData != null) {
      _currentUserData = cubit.cachedUserData!;
      _nameController.text = _currentUserData!.name;
      _emailController.text = _currentUserData!.email;
      _phoneController.text = _currentUserData!.phone;
      _genderController.text = _currentUserData!.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileCubit, UserProfileStates>(
          listener: (context, state) {
            if (state is UserProfileErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is UserProfileSucessState) {
              final userData = context.read<UserProfileCubit>().cachedUserData;
              if (userData != null) {
                setState(() {
                  _currentUserData = userData;
                  _nameController.text = userData.name;
                  _emailController.text = userData.email;
                  _phoneController.text = userData.phone;
                  _genderController.text = userData.gender;
                });
              }
            }
          },
        ),
        BlocListener<UserUpdateCubit, UserUpdateStates>(
          listener: (context, state) {
            if (state is UserUpdateErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is UserUpdateSucessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
              context.read<UserProfileCubit>().getUserProfile();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: RoundedBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconColor: Colors.black,),
          title: const Text(
            "Update Profile",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,

          actions: [
            CustomPopupMenu(
            ), // Your popup menu

          ],),
        body: BlocBuilder<UserProfileCubit, UserProfileStates>(
          builder: (context, state) {
            if (state is UserProfileInitialStates || state is UserProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserProfileErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.read<UserProfileCubit>().getUserProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return _buildProfileForm(context);
          },
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _buildTextField(_nameController, 'Name', Icons.person),
          const SizedBox(height: 16),
          _buildTextField(_emailController, 'Email', Icons.email),
          const SizedBox(height: 16),
          _buildTextField(_phoneController, 'Phone', Icons.phone),
          const SizedBox(height: 16),
          _buildTextField(_genderController, 'Gender', Icons.face_unlock_rounded), // Regular text field
          const SizedBox(height: 30),
          BlocBuilder<UserUpdateCubit, UserUpdateStates>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is UserUpdateLoadingState
                    ? null
                    : _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: state is UserUpdateLoadingState
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SAVE CHANGES', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _genderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    context.read<UserUpdateCubit>().updateUserProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      gender: _genderController.text,
    );
  }
}