
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/widgets.dart';
import '../view_models/attractions_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _scareLevels = const [
    'Mildly Haunted',
    'Zombies Ahead',
    'Absolute Terror',
  ];

  // Create the ViewModel
  final AttractionsViewModel _viewModel = AttractionsViewModel();

  @override
  void initState() {
    super.initState();

    // Load the haunt data when the screen opens
    _viewModel.loadAttractions();
  }

  @override
  void dispose() {
    // Clean up the ViewModel
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Spooky Find',
      ),

      // Automatically rebuild when the ViewModel changes
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          final visible = _viewModel.visibleAttractions;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Scare Level Dropdown
                ScareLevelDropdown(
                  selectedValue:
                      _scareLevels[_viewModel.maxScareLevel - 1],
                  items: _scareLevels,
                  onChanged: (String label) {
                    _viewModel.setMaxScareLevel(
                      _scareLevels.indexOf(label) + 1,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Loading, error, or haunt count
                if (_viewModel.isLoading)
                  const LinearProgressIndicator()
                else if (_viewModel.errorMessage != null)
                  Text(
                    _viewModel.errorMessage!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  )
                else
                  Text(
                    'Showing ${visible.length} of '
                    '${_viewModel.attractions.length} haunts',
                    style: textTheme.bodyMedium,
                  ),

                const SizedBox(height: 16),

                // Map with filtered haunt pins
                SpookyMap(attractions: visible),

                const SizedBox(height: 24),

                // Camera & Gallery Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/home/spoky_photo_home_button.svg',
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/home/open_library_button.svg',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
