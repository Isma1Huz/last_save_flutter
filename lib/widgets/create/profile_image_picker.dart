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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    
    // Background color for the avatar when no image is selected
    final avatarBackgroundColor = isDark 
        ? primaryColor.withOpacity(0.3) 
        : const Color(0xFFAFE1F6);
    
    // Text color for buttons
    final buttonTextColor = primaryColor;
    
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
                  : avatarBackgroundColor, 
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
                          color: isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          if (profileImage == null)
            Text(
              "Add picture",
              style: TextStyle(
                color: buttonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Change button
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.edit,
                    size: 18,
                    color: buttonTextColor,
                  ),
                  label: Text(
                    "Change",
                    style: TextStyle(
                      color: buttonTextColor,
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
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: buttonTextColor,
                  ),
                  label: Text(
                    "Remove",
                    style: TextStyle(
                      color: buttonTextColor,
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
