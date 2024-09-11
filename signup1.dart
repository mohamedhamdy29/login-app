import 'package:arabic_font/arabic_font.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search/auth/login1.dart';
import 'package:search/components/custombuttonauth.dart';

import 'package:search/components/customtextformpassword.dart';
import 'package:search/components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key:formState ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 30),
                // const CustomLogoAuth(),


                Center(
                  child: const Text(
                    'Register',
                    style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:25),
                  ),
                ),
                Container(height: 80),
                const Text(
                  'UserName',
                  style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:18),
                ),
                Container(height: 10),
                CustomTextForm(
                    hinttext: "ُEnter Your username",
                    mycontroller: username,
                    icon: Icons.person,
                    validator: (val) {
                      if (val == "") {
                        return "Username Required";
                      }
                    }),


                Container(height: 20),
                const Text(
                  'Email',
                  style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:18),
                ),
                Container(height: 10),
                CustomTextForm(
                    hinttext: "ُEnter Your Email",
                    mycontroller: email,
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email required";
                    }
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Invalid Email!";
                    }
                    return null;
                  },),






                Container(height: 10),
                const Text(
                  'Password',
                  style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:18),
                ),
                Container(height: 10),


                PasswordField(
                  controller: password,
                  hintText: 'Enter Your Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password Required";
                    }
                    if (value.length < 7) {
                      return "Password must be at least 7 characters!";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30,)
              ],
            ),
          ),
          CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  Login()),
                    );

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is too weak.',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The account already exists for that email',
                      ).show();

                    }
                    else if (e.code !.contains('@')) {
                      print('Email should contain @');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Email should contain @',
                      ).show();

                    }

                  } catch (e) {
                    print(e);
                  }
                }
              }),
          Container(height: 20),

          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  Login()),
              );

            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Color(0xFFDA9432), fontWeight: FontWeight.normal)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}