import 'dart:convert'; // Import this to use jsonDecode
import 'package:flutter/material.dart';
import 'package:healai/globals.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Import http package for API calls

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  // Variables to hold fetched data
  String? appointmentTime;
  String? doctorName;
  String? specialization;
  double? rating;
  String? location;
  String? contact;
  String? phone;
  double? latitude;
  double? longitude;
  String? calendarLink;
  String? uberLink;
  final String baseUrl = "10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    if (userCardFlag == 1) {
      fetchAppointmentDetails();
      fetchCalendarLink();
      fetchUberLink();
    }
  }

  Future<void> fetchAppointmentDetails() async {
    try {
      var appointmentUrl = Uri.http(baseUrl, '/prompt', {'prompt': inputText});
      final response = await http.post(appointmentUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        setState(() {
          appointmentTime = apiResponse['appointment']['appointment_time'];
          doctorName =
              apiResponse['appointment']['doctor_details']['doctor_name'];
          specialization =
              apiResponse['appointment']['doctor_details']['specialization'];
          rating = apiResponse['appointment']['doctor_details']['rating'];
          location = apiResponse['appointment']['doctor_details']['location'];
          contact = apiResponse['appointment']['doctor_details']['contact'];
          phone = apiResponse['appointment']['doctor_details']['phone'];
          latitude = apiResponse['appointment']['doctor_details']['latitude'];
          longitude = apiResponse['appointment']['doctor_details']['longitude'];
        });
      } else {
        throw Exception('Failed to load appointment data');
      }
    } catch (e) {
      print('Error fetching appointment details: $e');
    }
  }

  Future<void> fetchCalendarLink() async {
    try {
      var calendarUrl = Uri.http(baseUrl, '/calendar-link');
      final response = await http.get(calendarUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        setState(() {
          calendarLink = apiResponse['calendar_link'];
        });
      } else {
        throw Exception('Failed to load calendar link');
      }
    } catch (e) {
      print('Error fetching calendar link: $e');
    }
  }

  Future<void> fetchUberLink() async {
    try {
      var uberUrl = Uri.http(baseUrl, '/uber-deeplink');
      final response = await http.get(uberUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        setState(() {
          uberLink = apiResponse['deep_link'];
        });
      } else {
        throw Exception('Failed to load Uber link');
      }
    } catch (e) {
      print('Error fetching Uber link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Details',
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
            ? const Center(child: CircularProgressIndicator())
            : _buildAppointmentCard(),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      height: 400,
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
                'Doctor Name: $doctorName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Specialization: $specialization',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rating: ${rating?.toString() ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: $location',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Contact: $contact',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Phone: $phone',
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
              const SizedBox(height: 16),
              if (calendarLink != null)
                TextButton(
                  onPressed: () {
                    _launchURL(calendarLink!);
                  },
                  child: const Text(
                    'Add to your calendar by clicking on this link',
                    style: TextStyle(color: Color.fromARGB(255, 79, 255, 123)),
                  ),
                ),
              if (uberLink != null)
                TextButton(
                  onPressed: () {
                    _launchURL(uberLink!);
                  },
                  child: const Text(
                    'Book a cab to get there by clicking on the link',
                    style: TextStyle(color: Color.fromARGB(255, 105, 255, 68)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Convert the URL string to a Uri object
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
