import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full-width image at the top
              Image.asset(
                'assets/images/car-park.jpg',
                opacity: const AlwaysStoppedAnimation(.7),
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Menu buttons
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(context, 'Book A Space', '/book_space'),
                    _buildMenuItem(
                        context, 'Parking Spaces', '/parking_spaces'),
                    _buildMenuItem(
                        context, 'Booking History', '/booking_history'),
                    _buildMenuItem(context, 'Logout', '/logout'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
