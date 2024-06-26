import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone_app/authentication/consts.dart';
import 'package:youtube_clone_app/authentication/services/media_service.dart';
import 'package:youtube_clone_app/authentication/services/navigation_service.dart';
import 'package:youtube_clone_app/authentication/services/auth_service.dart'; // Import your AuthService
import 'package:youtube_clone_app/authentication/widgets/customFormField.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? email, password, name;
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService; // Initialize AuthService
  final _formKey = GlobalKey<FormState>();

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>(); // Get AuthService instance
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            headertext(),
            RegisterForm(),
            LoginAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget headertext() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget RegisterForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrflPicSelectionField(),
            CustomFormField(
              hintText: 'Enter your Name',
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: NAME_VALIDATION_REGEX,
              onSaved: (value) {
                name = value;
              },
            ),
            CustomFormField(
              hintText: 'Enter your Email',
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                email = value;
              },
            ),
            CustomFormField(
              hintText: 'Enter your Password',
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              onSaved: (value) {
                password = value;
              },
            ),
            RegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget PrflPicSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget RegisterButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save(); // Save the form fields
            bool registered = await _register();
            if (registered) {
              // Navigate to success page or home page
              _navigationService.goBack();
            } else {
              // Show error message
              showDialog(context: context, 
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Unable to create account. Please try again later'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop() , child: Text('Ok') )
                ],
              )
            );
              print('Unable to create');
            }
          } else {
            print('Please fill in all fields');
          }
        },
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<bool> _register() async {
    // Check if all fields are filled
    if (email == null || password == null || name == null || selectedImage == null) {
      print('Please fill in all fields');
      return false;
    }

    try {
      // Perform registration using AuthService
      bool result = await _authService.signUp(email!, password!, name!, selectedImage!);
      return result;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Widget LoginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Already have an account?"),
          GestureDetector(
            child: Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onTap: () {
              _navigationService.goBack();
            },
          )
        ],
      ),
    );
  }
}

