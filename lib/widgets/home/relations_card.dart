import 'package:flutter/material.dart';

class RelationsCard extends StatelessWidget {
  final String title;
  final double height;
  final VoidCallback? onTap;
  final List<String> relatedNames;

  const RelationsCard({
    super.key,
    this.title = 'Relations',
    this.height = 180,
    this.onTap,
    this.relatedNames = const ['', '', '', ''],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          onTap: onTap,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
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
              child: Padding(
                padding: const EdgeInsets.all(4),
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  
                  Center(
                    child: SizedBox(
                      width: 240,
                      height: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Center contact
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D2F34),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          
                          // Top contact
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _buildRelatedContact(
                                relatedNames.isNotEmpty ? relatedNames[0] : '',
                              ),
                            ),
                          ),
                          
                          // Right contact
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _buildRelatedContact(
                                relatedNames.length > 1 ? relatedNames[1] : '',
                              ),
                            ),
                          ),
                          
                          // Bottom contact
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _buildRelatedContact(
                                relatedNames.length > 2 ? relatedNames[2] : '',
                              ),
                            ),
                          ),
                          
                          // Left contact
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _buildRelatedContact(
                                relatedNames.length > 3 ? relatedNames[3] : '',
                              ),
                            ),
                          ),
                          
                          // Connection lines
                          CustomPaint(
                            size: const Size(240, 240),
                            painter: ConnectionsPainter(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // View button
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 16,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'View',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
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
        ),)
      ],
    );
  }

  Widget _buildRelatedContact(String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: name.isNotEmpty
              ? Center(
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        if (name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
      ],
    );
  }
}

class ConnectionsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = 30.0; // Radius of center circle
    final outerRadius = 90.0; // Distance to outer circles

    // Draw connection lines
    // Top
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy - outerRadius + 25),
      paint,
    );
    
    // Right
    canvas.drawLine(
      Offset(center.dx + radius, center.dy),
      Offset(center.dx + outerRadius - 25, center.dy),
      paint,
    );
    
    // Bottom
    canvas.drawLine(
      Offset(center.dx, center.dy + radius),
      Offset(center.dx, center.dy + outerRadius - 25),
      paint,
    );
    
    // Left
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx - outerRadius + 25, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}