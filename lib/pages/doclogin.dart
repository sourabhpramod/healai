import 'package:flutter/material.dart';
import 'package:healai/components/MyTextField.dart';
import 'package:healai/components/myButton.dart';
import 'package:healai/services/authservice.dart';

class DocLogin extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final void Function()? onTap;

  DocLogin({super.key, required this.onTap});

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
      appBar: AppBar(
        backgroundColor: Color(0xFF488A8F),
        title: Text(
          "Doctor Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
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
                "Start healing <3",
                style: TextStyle(
                  fontFamily: 'San Francisco',
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
                      fontFamily: 'San Francisco',
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
                        fontFamily: 'San Francisco',
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
    );
  }
}
