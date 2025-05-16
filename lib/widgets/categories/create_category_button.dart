import 'package:flutter/material.dart';

class CreateCategoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const CreateCategoryButton({
    Key? key, 
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0), 
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8), 
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: 16, 
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 16, 
          ),
        ),
        title: const Text(
          'Create category',
          style: TextStyle(
            fontWeight: FontWeight.w500, 
            fontSize: 14, 
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
