import 'package:batoflutter/models/api_response.dart';
import 'package:batoflutter/screens/home.dart';
import 'package:batoflutter/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/user.dart';
import '../services/user_services.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmationController = TextEditingController();

       void _registerUser () async {
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);
    if(response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } 
    else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            TextFormField(
              controller: nameController,
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              decoration: kInputDecoration('Name')
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: kInputDecoration('Email')
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (val) => val!.length < 8 ? 'Requires at least 8 chars' : null,
              decoration: kInputDecoration('Password')
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: passwordConfirmationController,
              obscureText: true,
              validator: (val) => val != passwordController.text ? 'Confirm password does not match' : null,
              decoration: kInputDecoration('Confirm password')
            ),
            const SizedBox(height: 20,),
            loading ? 
              Center(child: CircularProgressIndicator())
            : kTextButton('Register', () {
                if(formKey.currentState!.validate()){
                  setState(() {
                    loading = !loading;
                    _registerUser();
                  });
                }
              },
            ),
            SizedBox(height: 20,),
            kLoginRegisterHint('Already have an account? ', 'Login', (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login
              ()), (route) => false);
            })
          ],
        ),
      ),
    );
  }
}