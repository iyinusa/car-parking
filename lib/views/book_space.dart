import 'package:flutter/material.dart';

import '../controllers/booking_controller.dart';
import '../models/booking_model.dart';

class BookSpaceScreen extends StatefulWidget {
  const BookSpaceScreen({super.key});

  @override
  State<BookSpaceScreen> createState() => _BookSpaceScreenState();
}

class _BookSpaceScreenState extends State<BookSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookingModel _booking = BookingModel(
    spaceId: 'SP-1',
    bookingDate: DateTime.now(),
    carPlateNumber: '',
  );
  final BookingController _bookingController = BookingController();
  late DateTime _selectedDate = DateTime.now();
  String _selectedSpace = 'SP-1';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book A Space'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.85)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDatePicker(),
                    const SizedBox(height: 20),
                    _buildParkingSpacesGrid(),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Car Plate Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter car plate number';
                        }
                        // You can add more car plate number validation rules here if needed
                        return null;
                      },
                      onSaved: (value) {
                        _booking.carPlateNumber = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Book A Space'),
                    ),
                  ],
                ),
              ),
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
          'Select Booking Date',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text(_selectedDate.toString().split(' ')[0]),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _booking.bookingDate = picked;
      });
      print(_booking.bookingDate);
    }
  }

  Widget _buildParkingSpacesGrid() {
    // Mock list of parking spaces
    List<String> parkingSpaces =
        List.generate(20, (index) => 'SP-${index + 1}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Parking Space',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.5,
          ),
          itemCount: parkingSpaces.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedSpace = parkingSpaces[index];
                });

                _booking.spaceId = parkingSpaces[index];
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: _selectedSpace == parkingSpaces[index]
                          ? Colors.purple
                          : Colors.grey,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                    )),
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    parkingSpaces[index],
                    style: TextStyle(
                      fontWeight: _selectedSpace == parkingSpaces[index]
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String errorMessage = await _bookingController.bookSpace(_booking);
      if (errorMessage == '') {
        // Booking successful, navigate to another screen or perform desired action
        // For example, show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Space booked successfully'),
          backgroundColor: Colors.green,
        ));
        // Clear the form
        _formKey.currentState!.reset();
      } else {
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.purple,
        ));
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
