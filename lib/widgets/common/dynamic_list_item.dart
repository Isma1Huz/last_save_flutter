// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DynamicListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback onTap;

  final String? timestamp;
  final String? badge;
  final Color? badgeColor;
  final bool showChevron;
  final String? groupTag;

  final List<SlidableAction>? actions;

  const DynamicListItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.onTap,
    this.timestamp,
    this.badge,
    this.badgeColor,
    this.showChevron = false,
    this.groupTag,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget listTile = _buildListTile(context);

    if (actions == null || actions!.isEmpty) {
      return listTile;
    }

    return Slidable(
      key: key,
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.6,
        children: actions!
            .map(
              (action) => SlidableAction(
                onPressed: action.onPressed,
                backgroundColor: action.backgroundColor,
                foregroundColor: action.foregroundColor,
                icon: action.icon,
                borderRadius: action.borderRadius,
              ),
            )
            .toList(),
      ),
      child: listTile,
    );
  }

  Widget _buildListTile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final backgroundColor = isDark ? theme.cardColor : Colors.white;
    final dividerColor = isDark ? theme.dividerColor : Colors.grey.shade200;
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: dividerColor,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), 
      child: ListTile(
        dense: true, 
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4), 
        contentPadding: EdgeInsets.zero, 
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: theme.textTheme.titleMedium?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _buildSubtitle(context),
        trailing: _buildTrailing(context),
        onTap: onTap,
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (subtitle == null && timestamp == null) return null;
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final subtitleColor = isDark 
        ? theme.textTheme.bodySmall?.color 
        : Colors.grey.shade600;
    
    final timestampColor = isDark 
        ? theme.textTheme.bodySmall?.color?.withOpacity(0.7) 
        : Colors.grey.shade500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (timestamp != null)
          Text(
            timestamp!,
            style: TextStyle(
              color: timestampColor,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget? _buildTrailing(BuildContext context) {
    List<Widget> trailingWidgets = [];
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final effectiveBadgeColor = badgeColor ?? theme.colorScheme.primary;
    
    if (badge != null) {
      trailingWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          decoration: BoxDecoration(
            color: effectiveBadgeColor.withOpacity(isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge!,
            style: TextStyle(
              fontSize: 12,
              color: effectiveBadgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (trailingWidgets.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: trailingWidgets,
    );
  }
}
