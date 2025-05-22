import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/utils/contact_action_helper.dart';
import 'package:last_save/widgets/common/contact_avatar.dart';

class ExpandableContactItem extends StatefulWidget {
  final Contact contact;
  final VoidCallback onViewContact;
  final String? timestamp;
  final String? badge;
  final bool showChevron;
  final String? groupTag;
  final List<SlidableAction>? actions;

  const ExpandableContactItem({
    Key? key,
    required this.contact,
    required this.onViewContact,
    this.timestamp,
    this.badge,
    this.showChevron = false,
    this.groupTag,
    this.actions,
  }) : super(key: key);

  @override
  State<ExpandableContactItem> createState() => _ExpandableContactItemState();
}

class _ExpandableContactItemState extends State<ExpandableContactItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final Widget contactTile = _buildContactTile(context);

    if (widget.actions == null || widget.actions!.isEmpty) {
      return contactTile;
    }

    return Slidable(
      key: widget.key,
      groupTag: widget.groupTag,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.6,
        children: widget.actions!
            .map(
              (action) => SlidableAction(
                onPressed: action.onPressed,
                backgroundColor: action.backgroundColor,
                foregroundColor: action.foregroundColor,
                icon: action.icon,
                label: action.label,
                borderRadius: action.borderRadius,
              ),
            )
            .toList(),
      ),
      child: contactTile,
    );
  }

  Widget _buildContactTile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final backgroundColor = isDark ? theme.cardColor : Colors.white;
    final dividerColor = isDark ? theme.dividerColor : Colors.grey.shade200;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _toggleExpanded,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: _isExpanded ? Colors.transparent : dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              contentPadding: EdgeInsets.zero,
              leading: ContactAvatar(contact: widget.contact),
              title: Text(
                widget.contact.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: theme.textTheme.titleMedium?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: _buildSubtitle(context),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.badge!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.call,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      ContactActionsHelper.makePhoneCallAlternative(
                        context, 
                        widget.contact.phoneNumber
                      );
                    },
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.iconTheme.color?.withOpacity(0.7),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Expandable 
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.phone,
                      label: 'Call',
                      onTap: () {
                       ContactActionsHelper.makePhoneCall(
                        context, 
                        widget.contact.phoneNumber
                      );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.message,
                      label: 'Message',
                      onTap: () {
                        ContactActionsHelper.sendMessageAlternative(
                          context, 
                          widget.contact.phoneNumber
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.history,
                      label: 'History',
                      onTap: () {
                        ContactActionsHelper.openCallHistory(context, widget.contact);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: widget.onViewContact,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                    minimumSize: const Size(double.infinity, 36),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('View Contact'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
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
        Text(
          widget.contact.phoneNumber,
          style: TextStyle(
            color: subtitleColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.timestamp != null)
          Text(
            widget.timestamp!,
            style: TextStyle(
              color: timestampColor,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
