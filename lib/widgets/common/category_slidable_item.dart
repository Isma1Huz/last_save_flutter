import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/widgets/common/dynamic_list_item.dart';

class CategorySlidableItem extends StatelessWidget {
  final Category category;
  final String subtitle;
  final VoidCallback onTap;
  final String? timestamp;
  final String? badge;
  final bool showChevron;

  final String? groupTag;
  final List<SlidableAction>? actions;

  const CategorySlidableItem({
    Key? key,
    required this.category,
    required this.subtitle,
    required this.onTap,
    this.timestamp,
    this.badge,
    this.showChevron = false,
    this.groupTag,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DynamicListItem(
      title: category.title,
      subtitle: subtitle,
      leading: CircleAvatar(
        radius: 16,
        child: Icon(
          Category.availableIcons[category.iconIndex],
          color: Colors.white,
          size: 16,
        ),
      ),
      onTap: onTap,
      timestamp: timestamp,
      badge: badge,
      badgeColor: theme.colorScheme.primary,
      showChevron: showChevron,
      groupTag: groupTag,
      actions: actions,
    );
  }
}
