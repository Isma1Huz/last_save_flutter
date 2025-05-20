import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FullMapScreen extends StatefulWidget {
  final LatLng location;

  const FullMapScreen({
    super.key,
    required this.location,
  });

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  late MapController _mapController;
  
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Enhanced map styles for better dark mode appearance
    final mapStyle = isDarkMode
        // Using a more colorful dark theme with rich blues instead of plain black
        ? 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

    return Scaffold(
      body: Stack(
        children: [
          // Full screen map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.location,
              initialZoom: 15,
              onMapReady: () {
                // Map is ready
              },
            ),
            children: [
              TileLayer(
                urlTemplate: mapStyle,
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
                // Adjust opacity for dark mode to enhance colors
              ),
              
              // Add a color overlay for dark mode to enhance the visual appeal
              if (isDarkMode)
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Color.fromRGBO(100, 120, 180, 0.1), // Subtle blue tint
                    BlendMode.overlay,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50,
                    height: 50,
                    point: widget.location,
                    child: _buildMarker(isDarkMode),
                  ),
                ],
              ),
            ],
          ),
          
          // Modern back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          
          // Modern location button
          Positioned(
            bottom: 30,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zoom in button
                _buildMapButton(
                  icon: Icons.add,
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom + 1);
                  },
                  isDarkMode: isDarkMode,
                ),
                
                const SizedBox(height: 8),
                
                // Zoom out button
                _buildMapButton(
                  icon: Icons.remove,
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom - 1);
                  },
                  isDarkMode: isDarkMode,
                ),
                
                const SizedBox(height: 8),
                
                // My location button
                _buildMapButton(
                  icon: Icons.my_location,
                  onTap: () {
                    // Center map on user location
                    // In a real app, you would get the user's location first
                    _mapController.move(widget.location, 15);
                  },
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          
          // Search bar at the top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 70,
            right: 16,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search for a place or address',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white38 : Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMarker(bool isDarkMode) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        
        // Inner circle (Bolt uses their brand color)
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.blue[400] : const Color(0xFF33CC66), // Changed to blue in dark mode
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
