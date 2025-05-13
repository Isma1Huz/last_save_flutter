import 'package:flutter/material.dart';
import 'package:last_save/widgets/home/places_map_card.dart';
import 'package:last_save/widgets/home/relations_card.dart';

class PlacesRelationsSection extends StatelessWidget {
  const PlacesRelationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: PlacesMapCard()),
        SizedBox(width: 16),
        Expanded(child: RelationsCard()),
      ],
    );
  }
}
