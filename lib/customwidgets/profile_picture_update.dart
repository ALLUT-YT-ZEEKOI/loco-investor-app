import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureUpdate extends StatefulWidget {
  const ProfilePictureUpdate({super.key});

  @override
  State<ProfilePictureUpdate> createState() => _CameraOrGalleryBoxState();
}

class _CameraOrGalleryBoxState extends State<ProfilePictureUpdate> {
  final ImagePicker _picker = ImagePicker();

  void _showPickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Open Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  // Do something with the image

                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Open Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
      
         
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 166, 166, 173),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Image.asset(
          'assets/camer_img.png',
          width: 50,
        )),
      ),
    );
  }
}
