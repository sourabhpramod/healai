import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // Correct import for MediaType

class ReportUploadPage extends StatefulWidget {
  @override
  _ReportUploadPageState createState() => _ReportUploadPageState();
}

class _ReportUploadPageState extends State<ReportUploadPage> {
  File? _selectedFile;
  String? _appointmentText;
  bool _isLoading = false;
  final String baseUrl =
      "10.0.2.2:8000"; // Ensure this URL points to your API server

  final picker = ImagePicker();

  // Function to pick the file
  Future<void> _pickFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  // Function to upload the selected file
  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    // Extracting the filename
    String fileName = path.basename(_selectedFile!.path);

    // Construct the URI
    var uri = Uri.http(baseUrl, '/uploadfile/');
    var request = http.MultipartRequest('POST', uri);

    // Detect MIME type of the file
    var mimeType = lookupMimeType(_selectedFile!.path);

    if (mimeType == null) {
      setState(() {
        _appointmentText = 'Unsupported file type';
        _isLoading = false;
      });
      return;
    }

    var mimeSplit =
        mimeType.split('/'); // Split the MIME type into type/subtype

    // Add file to the request with the correct content type
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // This is the key that your server expects
        _selectedFile!.path,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]), // Correct MediaType
      ),
    );

    try {
      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        // Decode the response
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        // Display the appointment text
        setState(() {
          _appointmentText = jsonResponse['appointment'];
        });
      } else {
        setState(() {
          _appointmentText = 'Error uploading file';
        });
      }
    } catch (e) {
      setState(() {
        _appointmentText = 'Error: $e';
      });
    }

    // Reset loading state
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Report Upload',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 43, 81, 83),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _selectedFile == null
                  ? Text(
                      'No file selected.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 43, 81, 83),
                        fontSize: 16,
                      ),
                    )
                  : Text(
                      'File selected: ${path.basename(_selectedFile!.path)}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 43, 81, 83),
                        fontSize: 16,
                      ),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 43, 81, 83),
                  foregroundColor: Colors.white, // Background color
                  textStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: _pickFile,
                child: Text('Pick Medical Report'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 43, 81, 83),
                  foregroundColor: Colors.white, // Background color
                  textStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: _uploadFile,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Upload File'),
              ),
              SizedBox(height: 20),
              if (_appointmentText != null)
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Appointment: $_appointmentText',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 43, 81, 83),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
