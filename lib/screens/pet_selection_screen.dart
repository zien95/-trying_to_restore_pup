import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/game_provider.dart';

class PetSelectionScreen extends StatelessWidget {
  const PetSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7B1FA2),
              Color(0xFFE91E63),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pick Your Pet',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.pets,
                    color: Colors.white.withOpacity(0.8),
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Pet options
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  children: [
                    _PetOption(
                      type: PetType.dog,
                      onTap: () => _selectPet(context, PetType.dog),
                    ),
                    const SizedBox(height: 16),
                    _PetOption(
                      type: PetType.cat,
                      onTap: () => _selectPet(context, PetType.cat),
                    ),
                    const SizedBox(height: 16),
                    _PetOption(
                      type: PetType.bunny,
                      onTap: () => _selectPet(context, PetType.bunny),
                    ),
                    const SizedBox(height: 16),
                    _PetOption(
                      type: PetType.bird,
                      onTap: () => _selectPet(context, PetType.bird),
                    ),
                    const SizedBox(height: 16),
                    _PetOption(
                      type: PetType.dragon,
                      onTap: () => _selectPet(context, PetType.dragon),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectPet(BuildContext context, PetType type) {
    context.read<GameProvider>().playClickSound();
    showDialog(
      context: context,
      builder: (context) => _NamePetDialog(type: type),
    );
  }
}

class _PetOption extends StatelessWidget {
  final PetType type;
  final VoidCallback onTap;

  const _PetOption({
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 16),
            Text(
              type.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7B1FA2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NamePetDialog extends StatefulWidget {
  final PetType type;

  const _NamePetDialog({required this.type});

  @override
  State<_NamePetDialog> createState() => _NamePetDialogState();
}

class _NamePetDialogState extends State<_NamePetDialog> {
  final _controller = TextEditingController(text: 'Buddy');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2D2D3A),
      title: const Text(
        'Name Your Pet',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF1E1E2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'Enter pet name',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<GameProvider>().playClickSound();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isNotEmpty) {
              context.read<GameProvider>().createPet(name, widget.type);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B1FA2),
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
