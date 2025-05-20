import 'package:flutter/material.dart';
import 'package:last_save/widgets/home/places_map_card.dart';
import 'package:last_save/widgets/home/relations_card.dart';

class PlacesRelationsSection extends StatelessWidget {
  const PlacesRelationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: ModernMapCard()),
        const SizedBox(width: 16),
        Expanded(child:  
            RelationsCard(
              title: 'Relations',
              height: 180,
              relatedNames: const ['John', 'Sarah', 'Mike', 'Lisa'],
              onTap: () {},
            ),),
      ],
    );
  }
}
