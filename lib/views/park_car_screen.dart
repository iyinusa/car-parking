import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/park_car_controller.dart';
import '../models/park_car_model.dart';

class ParkMyCarScreen extends StatefulWidget {
  final String? title;
  const ParkMyCarScreen({super.key, this.title});

  @override
  State<ParkMyCarScreen> createState() => _ParkMyCarScreenState();
}

class _ParkMyCarScreenState extends State<ParkMyCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final ParkMyCarModel _parkMyCar =
      ParkMyCarModel(selectedDate: DateTime.now(), plateNumber: '');
  final ParkMyCarController _parkMyCarController = ParkMyCarController();
  late File _imageFile = File('');
  String _plateNumber = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Park My Car'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePicker(),
                const SizedBox(height: 20),
                _buildPlateNumberScanner(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.title ?? 'Park My Car'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booked Date',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text(
              _parkMyCar.selectedDate == null
                  ? 'Select Date'
                  : _parkMyCar.selectedDate.toString().split(' ')[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parkMyCar.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _parkMyCar.selectedDate) {
      setState(() {
        _parkMyCar.selectedDate = picked;
      });
    }
  }

  Widget _buildPlateNumberScanner() {
    return GestureDetector(
      onTap: () {
        _scanPlateNumber();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageFile.path.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 250,
                          color: Colors.grey.shade300,
                        ),
                        Text(
                          'Scan Plate Number',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.file(
                        _imageFile,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _plateNumber,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanPlateNumber() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _textRecognition(_imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _textRecognition(File img) async {
    final scannedImage = InputImage.fromFilePath(img.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(scannedImage);
    String extractedText = recognizedText.text;

    setState(() {
      _plateNumber = extractedText;
    });

    print(_plateNumber);
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });

    if (_plateNumber == '') {
      // Show result to the user
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Car Plate Number Not Scanned'),
      ));
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        // Check booking for the car on the selected date
        String result = await _parkMyCarController.checkBooking(_parkMyCar);

        // Send push notification with the result
        await _parkMyCarController.sendPushNotification(result);

        // Show result to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result),
        ));

        // Clear the form
        _formKey.currentState!.reset();
        setState(() {
          _parkMyCar.selectedDate = DateTime.now();
          _parkMyCar.plateNumber = '';
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
