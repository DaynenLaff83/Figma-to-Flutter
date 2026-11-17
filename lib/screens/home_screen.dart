
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/attraction.dart';
import '../widgets/widgets.dart';
import '../view_models/attractions_view_model.dart';
import '../view_models/location_view_model.dart';

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

  // Create the ViewModels
  final AttractionsViewModel _viewModel = AttractionsViewModel();
  final LocationViewModel _locationViewModel = LocationViewModel();

  @override
  void initState() {
    super.initState();

    // Load the haunt data when the screen opens
    _viewModel.loadAttractions();
    _locationViewModel.findUser();
  }

  @override
  void dispose() {
    // Clean up the ViewModels
    _viewModel.dispose();
    _locationViewModel.dispose();
    super.dispose();
  }

  // Step 5: Opens the haunt details popup
  void _showDetails(Attraction attraction) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => HauntDetailsSheet(
        attraction: attraction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Spooky Find',
      ),

      // Automatically rebuild when either ViewModel changes
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _viewModel,
          _locationViewModel,
        ]),
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

                // Location status
                if (_locationViewModel.isLocating)
                  Text(
                    'Finding your location…',
                    style: textTheme.bodySmall,
                  )
                else if (_locationViewModel.problem != null)
                  Text(
                    'Showing home base: ${_locationViewModel.problem}',
                    style: textTheme.bodySmall,
                  ),

                const SizedBox(height: 16),

                // Map with tappable haunt pins
                SpookyMap(
                  attractions: visible,
                  userLocation: _locationViewModel.userLocation,
                  onAttractionTapped: _showDetails,
                ),

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
