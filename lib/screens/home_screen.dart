import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> _scareLevels = const [
    'Mildly Haunted',
    'Zombies Ahead',
    'Absolute Terror',
  ];

  @override
  Widget build(BuildContext context) {
    const selectedLevel = 'Mildly Haunted';

    return Scaffold(
      appBar: const AppHeader(
        title: 'SpookyFind',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            ScareLevelDropdown(
              selectedValue: selectedLevel,
              items: _scareLevels,
            ),

            const SizedBox(height: 24),

            const MapPlaceholder(),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_library),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
