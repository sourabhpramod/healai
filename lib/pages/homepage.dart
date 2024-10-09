import 'package:flutter/material.dart';
import 'package:healai/globals.dart';
import 'package:healai/pages/appointments.dart';
import 'package:healai/pages/scan.dart';
import 'dart:async';
import 'package:healai/services/authservice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _messagesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false; // To track loading state
  final String baseUrl = "10.0.2.2:8000";
  String _lastInputText = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initAgents() async {
    var userUrl = Uri.http(baseUrl, '/user');
    await http.post(userUrl);
    print("User Post successful");
    var doctorUrl = Uri.http(baseUrl, '/doctor');
    await http.post(doctorUrl);
    print("Doctor Post successful");
    var healerUrl = Uri.http(baseUrl, '/healer');
    await http.post(healerUrl);
    print("Healer Post successful");
  }

  void logout() {
    final auth = AuthService();
    auth.singOut();
  }

  Future<void> send() async {
    var text = _textEditingController.text;
    text = text.toLowerCase();
    await initAgents();
    if (text.isNotEmpty) {
      _messages.add({'text': text, 'isUser': true}); // Add user message
      _textEditingController.clear();
      _messagesController.add(List.from(_messages)); // Update stream
      _lastInputText = text;
      inputText = text;
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate response after a short delay
      var promptUrl = Uri.http(baseUrl, '/prompt', {'prompt': text});
      try {
        final response = await http.post(
          promptUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        if (response.statusCode == 200) {
          // Successfully posted, get the response data
          final responseData = jsonDecode(response.body);
          // Assuming responseData['dishes'] contains the dishes array
          final apiResponse = responseData ?? 'No response message';

          // Format the response data
          String formattedResponse =
              'Appointment Time: ${apiResponse['appointment']['appointment_time']}\n'
              'Doctor Name: ${apiResponse['appointment']['doctor_details']['doctor_name']}\n'
              'Specialization: ${apiResponse['appointment']['doctor_details']['specialization']}\n'
              'Rating: ${apiResponse['appointment']['doctor_details']['rating']}\n'
              'Location: ${apiResponse['appointment']['doctor_details']['location']}\n'
              'Phone: ${apiResponse['appointment']['doctor_details']['phone']}';

          // Add formatted API response to messages
          _messages.add({
            'text': formattedResponse,
            'isUser': false,
            'showButtons': true
          });
          _messagesController.add(List.from(_messages)); // Update stream
        } else if (response.statusCode == 422) {
          print('Unprocessable Entity: ${response.body}');
        } else {
          print(
              'Failed to post prompt data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        print('Error: $e');
      }
    }
  }

  Future<void> rejection() async {
    // Simulate rejection action
    if (_lastInputText.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      var promptUrl = Uri.https(baseUrl, '/prompt', {'prompt': _lastInputText});
      try {
        final response = await http.post(
          promptUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        if (response.statusCode == 200) {
          // Successfully posted, get the response data
          final responseData = jsonDecode(response.body);
          // Assuming responseData['dishes'] contains the dishes array
          final apiResponse = responseData ?? 'No response message';

          // Format the response data
          String formattedResponse =
              'Appointment Time: ${apiResponse['appointment']['appointment_time']}\n'
              'Doctor Name: ${apiResponse['appointment']['doctor_details']['doctor_name']}\n'
              'Specialization: ${apiResponse['appointment']['doctor_details']['specialization']}\n'
              'Rating: ${apiResponse['appointment']['doctor_details']['rating']}\n'
              'Location: ${apiResponse['appointment']['doctor_details']['location']}\n'
              'Phone: ${apiResponse['appointment']['doctor_details']['phone']}';

          // Add formatted API response to messages
          _messages.add({
            'text': formattedResponse,
            'isUser': false,
            'showButtons': true
          });
          _messagesController.add(List.from(_messages)); // Update stream
        } else if (response.statusCode == 422) {
          print('Unprocessable Entity: ${response.body}');
        } else {
          print(
              'Failed to post prompt data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        print('Error: $e');
      }
    }
  }

  Future<void> accepted() async {
    // Simulate acceptance action
    _messages.add({
      'text': "Confirming your appointment with your doctor. Please wait...",
      'isUser': false,
      'showButtons': false
    });
    _messagesController.add(List.from(_messages));

    var confirmUrl = Uri.http(baseUrl, '/confirm', {
      'req': 'true',
    });

    final response = await http.post(
      confirmUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {}), // Empty body since the request only needs the query parameter
    );

    if (response.statusCode == 200) {
      // Successfully confirmed the order
      print("Appointment confirmed");
      userConfirmFlag = 1;
      _messages.add({
        'text': "Appointment confirmed! Get well soon...",
        'isUser': false,
        'showButtons': false
      });
      _messagesController.add(List.from(_messages));
      userCardFlag = 1;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _messagesController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 43, 81, 91),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
            print("check confirm");
          },
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 43, 81, 91),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 43, 81, 91),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt, // Camera icon for scanning medical report
                color: Colors.white,
              ),
              title: const Text(
                'Scan your medical report',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReportUploadPage()), // Navigate to SecondPage
                );
                // Add functionality for scanning medical reports
                print('Scan your medical report tapped');
                // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons
                    .medical_services, // Medical icon for upcoming appointments
                color: Colors.white,
              ),
              title: const Text(
                'Booked Appointments',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Appointments()), // Navigate to SecondPage
                );
                // Add functionality for scanning medical reports
                print('Scan your medical report tapped');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout, // Logout icon
                color: Colors.white,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: logout, // Define your logout function
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesController.stream,
              builder: (context, snapshot) {
                if (_isLoading) {
                  return const Center(
                    child: Text(
                      "Finding the best doctors...",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: Color.fromARGB(255, 43, 81, 83),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text(
                      "Tell us your Symptoms",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: Color.fromARGB(255, 43, 81, 83),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index];
                      final isUserMessage = message['isUser'] ?? false;
                      final showButtons = message['showButtons'] ?? false;

                      return Column(
                        crossAxisAlignment: isUserMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (index > 0)
                            const SizedBox(
                              height: 10,
                            ), // SizedBox between messages
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Color.fromARGB(255, 43, 81, 83)
                                  : Color.fromRGBO(0, 0, 0, 1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),
                                ),
                                if (showButtons)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color:
                                              Color.fromARGB(255, 0, 255, 106),
                                        ),
                                        onPressed: accepted,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed: rejection,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Tell us your symptoms'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 43, 81, 83)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 43, 81, 83)),
                      ),
                      labelText: 'Enter your Symptoms',
                      labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 43, 81, 83)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  color: const Color.fromARGB(255, 43, 81, 83),
                  onPressed: send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
