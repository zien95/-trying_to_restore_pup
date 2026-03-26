import 'package:flutter/material.dart';

class PetSharingScreen extends StatefulWidget {
  const PetSharingScreen({super.key});

  @override
  State<PetSharingScreen> createState() => _PetSharingScreenState();
}

class _PetSharingScreenState extends State<PetSharingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FA2),
        title: const Text(
          '🐾 Pet Sharing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          'Pet Sharing Feature Coming Soon!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
