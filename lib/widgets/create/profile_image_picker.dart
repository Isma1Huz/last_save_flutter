import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatelessWidget {
  final File? profileImage;
  final Function(File) onImagePicked;
  final VoidCallback? onImageRemoved;

  const ProfileImageWidget({
    Key? key,
    required this.profileImage,
    required this.onImagePicked,
    this.onImageRemoved,
  }) : super(key: key);

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      onImagePicked(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
      children: [
        // Profile Image Circle
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: profileImage != null 
                ? Colors.transparent 
                : const Color(0xFFAFE1F6), // Light blue background when no image
            child: profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.file(
                      profileImage!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Text or Action Buttons
        if (profileImage == null)
          // Show "Add picture" text when no image
          const Text(
            "Add picture",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        else
          // Show Change and Remove buttons when image is selected
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Change button
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.blue,
                ),
                label: const Text(
                  "Change",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Remove button
              TextButton.icon(
                onPressed: onImageRemoved ?? () {
                  // If no callback is provided, create a default one
                  if (onImageRemoved == null) {
                    debugPrint('No onImageRemoved callback provided');
                  }
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.blue,
                ),
                label: const Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
      ],
    ),
    );
  }
}