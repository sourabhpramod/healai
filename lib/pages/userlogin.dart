import 'package:flutter/material.dart';
import 'package:healai/components/MyTextField.dart';
import 'package:healai/components/myButton.dart';
import 'package:healai/services/authservice.dart';
import 'package:healai/services/docauthgate.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
          _emailcontroller.text, _passwordcontroller.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(
            e.toString(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon.jpg',
                      width: 400, // Adjust width as needed
                      height: 400, // Adjust height as needed
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Get Healed <3",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Color(0xFF488A8F),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextfield(
                      hintText: 'Email',
                      obsecure: false,
                      controller: _emailcontroller,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextfield(
                      hintText: 'Password',
                      obsecure: true,
                      controller: _passwordcontroller,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    myButton(
                      text: "Login",
                      onTap: () => login(context),
                    ),
                    const SizedBox(
                      height: 12.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member? ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color(0xFF488A8F),
                          ),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocAuthGate()),
                        );
                      }
                    },
                    child: Text(
                      "Doctor",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
