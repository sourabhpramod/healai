import 'dart:convert'; // Import this to use jsonDecode
import 'package:flutter/material.dart';
import 'package:healai/globals.dart';
import 'package:http/http.dart' as http; // Import http package for API calls

class DocHomePage extends StatefulWidget {
  const DocHomePage({super.key});

  @override
  _DocHomePageState createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  // Variables to hold patient data
  String? appointmentTime;
  String? patientId;
  String? patientMessage;
  List<dynamic>? patientLocation;
  final String baseUrl = "10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    if (userConfirmFlag == 1) {
      fetchUpcomingSession();
    } // Fetch data when the widget initializes
  }

  Future<void> fetchUpcomingSession() async {
    try {
      var appointmentUrl = Uri.http(baseUrl, '/upcoming_sessions');

      final response = await http.get(appointmentUrl);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        setState(() {
          appointmentTime = apiResponse['upcoming_sessions']['date'];
          patientId = apiResponse['upcoming_sessions']['patient_id'];
          patientMessage = apiResponse['upcoming_sessions']['patient_message'];
          patientLocation =
              apiResponse['upcoming_sessions']['patient_location'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching upcoming sessions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upcoming Appointment',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 43, 81, 91),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: appointmentTime == null
            ? // Check if appointment data is loaded
            const Center(child: CircularProgressIndicator())
            : // Show loading indicator
            _buildAppointmentCard(),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      height: 350, // Set a specific height for the card
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        color: const Color.fromARGB(255, 43, 81, 91),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient ID: $patientId',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Patient Message: $patientMessage',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Appointment Time: ${appointmentTime ?? 'N/A'}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Patient Location: ${patientLocation != null ? 'Lat: ${patientLocation![0]}, Long: ${patientLocation![1]}' : 'N/A'}',
                    style: const TextStyle(
                      color: Colors.white,
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
