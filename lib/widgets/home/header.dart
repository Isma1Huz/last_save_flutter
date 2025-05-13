import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email ?? 'Guest';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 16,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Hello, ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
