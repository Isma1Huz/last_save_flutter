// import 'package:flutter/material.dart';
// import 'package:last_save/models/contact.dart';
// import 'package:last_save/utils/contact_action_helper.dart';

// class ContactActionSheet extends StatelessWidget {
//   final Contact contact;

//   const ContactActionSheet({
//     Key? key,
//     required this.contact,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final hasPhoneNumber = contact.phoneNumber.isNotEmpty;
//     final hasEmail = contact.email != null && contact.email!.isNotEmpty;
//     final hasAddress = contact.addresses != null && contact.addresses!.isNotEmpty;

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         color: theme.scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           Text(
//             'Contact ${contact.name}',
//             style: theme.textTheme.titleLarge,
//           ),
//           const SizedBox(height: 24),
//           if (hasPhoneNumber) ...[
//             _buildActionTile(
//               context,
//               icon: Icons.call,
//               iconColor: Colors.green,
//               title: 'Call',
//               subtitle: contact.phoneNumber,
//               onTap: () {
//                 Navigator.pop(context);
//                 ContactActionsHelper.makePhoneCall(context, contact.phoneNumber);
//               },
//             ),
//             _buildActionTile(
//               context,
//               icon: Icons.message,
//               iconColor: Colors.blue,
//               title: 'Message',
//               subtitle: contact.phoneNumber,
//               onTap: () {
//                 Navigator.pop(context);
//                 ContactActionsHelper.sendMessage(context, contact.phoneNumber);
//               },
//             ),
//           ],
//           const SizedBox(height: 16),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionTile(
//     BuildContext context, {
//     required IconData icon,
//     required Color iconColor,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: iconColor.withOpacity(0.1),
//         child: Icon(icon, color: iconColor),
//       ),
//       title: Text(title),
//       subtitle: Text(
//         subtitle,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//       onTap: onTap,
//     );
//   }

//   String _getAddressPreview(Map<String, String> addressMap) {
//     final city = addressMap['city'] ?? '';
//     final state = addressMap['state'] ?? '';
    
//     if (city.isNotEmpty && state.isNotEmpty) {
//       return '$city, $state';
//     } else if (city.isNotEmpty) {
//       return city;
//     } else if (state.isNotEmpty) {
//       return state;
//     } else {
//       return 'View address on map';
//     }
//   }
// }
