import 'package:flutter/material.dart';
import 'package:healai/components/MyTextField.dart';
import 'package:healai/components/myButton.dart';
import 'package:healai/services/authservice.dart';

class DocReg extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmPasswordcontroller =
      TextEditingController();
  DocReg({super.key, required this.onTap});

  void register(BuildContext context) {
    if (_passwordcontroller.text == _confirmPasswordcontroller.text) {
      try {
        final auth = AuthService();
        auth.singUpWithEmailAndPassword(
            _emailcontroller.text, _passwordcontroller.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            title: Text(
              e.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
    //later
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                "Start healing! Become a partner.",
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
              MyTextfield(
                hintText: 'Confirm Password',
                obsecure: true,
                controller: _confirmPasswordcontroller,
              ),
              const SizedBox(
                height: 25,
              ),
              myButton(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(
                height: 12.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member? ",
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
                      "Login Now",
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
