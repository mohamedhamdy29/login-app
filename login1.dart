import 'package:arabic_font/arabic_font.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:search/auth/signup1.dart';
import 'package:search/components/custombuttonauth.dart';

import 'package:search/components/customtextformpassword.dart';
import 'package:search/components/textformfield.dart';





class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();



  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser==null){
      return;

    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  FirstScreen()),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 5),


                Center(
                  child: const Text(
                    'Login',
                    style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:25),
                  ),
                ),
                SizedBox(height: 10,),

                Container(height: 20),
                const Text(
                  'Email',
                  style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:18,),
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
                  style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:18,),
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







                InkWell(
                  onTap: () async {
                    if(email.text =="") {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Write your email',
                      ).show();
                      return;
                    }

                    try {

                      // Send password reset email
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Done',
                        desc: 'Password reset has been sent. Please check your email.',
                      ).show();
                    } catch(e) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Make sure you have entered a previously registered email.',
                      ).show();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),





          CustomButtonAuth(
              title: "login",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: email.text, password: password.text);
                    if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("FirstScreen");
                    } else {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc:
                        'الرجاء التوجه على بريدك الالكتروني والضفط على لينك التحقق من البريد حتى يتم تفعيل حسابك',
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'No user found for that email.',
                      ).show();
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Wrong password provided for that user',
                      ).show();
                    }
                  }
                }

              }),
          Container(height: 20),

          MaterialButton(
            height: 40,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Color(0xFFFFE7C7),
            textColor: Colors.black,
            onPressed: () {

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login With Google',
                  style: ArabicTextStyle(arabicFont: ArabicFont.arefRuqaa,fontSize:18),
                ),
                SizedBox(width: 6,),

              ],
            ),
          ),

          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  SignUp()),
              );

            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Don't Have An Account ? ",style: TextStyle(fontFamily:ArabicFont.arefRuqaa),
                ),
                TextSpan(
                    text: "Register",
                    style: TextStyle(
                        color: Color(0xFFDA9432),fontFamily:ArabicFont.arefRuqaa )),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the First Screen!',
              style: TextStyle(fontSize: 24),
            ),

          ],
        ),
      ),
    );
  }
}