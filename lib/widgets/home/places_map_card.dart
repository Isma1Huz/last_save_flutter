import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:last_save/screens/map_screen.dart';

class ModernMapCard extends StatelessWidget {
  final LatLng location;
  final String title;
  final double height;
  final VoidCallback? onTap;

  const ModernMapCard({
    super.key,
    this.location = const LatLng(-1.286389, 36.817223),
    this.title = 'Places',
    this.height = 180,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final mapStyle = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

    void navigateToMapScreen() {
      if (onTap != null) {
        onTap!();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullMapScreen(location: location),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
        GestureDetector(
          onTap: navigateToMapScreen, 
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Map
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: location,
                      initialZoom: 15,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: mapStyle,
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.app',
                        tileProvider: NetworkTileProvider(),
                      ),
                      
                      if (isDarkMode)
                        ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(100, 120, 180, 0.1), 
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
                            point: location,
                            child: const BoltStyleMarker(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            isDarkMode 
                                ? Colors.black.withOpacity(0.4) 
                                : Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: GestureDetector(
                      onTap: navigateToMapScreen, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 16,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'View',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BoltStyleMarker extends StatefulWidget {
  const BoltStyleMarker({super.key});

  @override
  State<BoltStyleMarker> createState() => _BoltStyleMarkerState();
}

class _BoltStyleMarkerState extends State<BoltStyleMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final pulseColor = isDarkMode ? Colors.blue[300] : Colors.black;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 40 * _scaleAnimation.value,
                height: 40 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  color: pulseColor?.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        
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
        
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.blue[400] : const Color(0xFF33CC66),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
