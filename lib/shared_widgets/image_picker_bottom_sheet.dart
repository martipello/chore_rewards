import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  static Future<ImageSource?> showImagePicker(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return ImagePickerBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImagePickerButton(
          ImageSource.camera,
          Icons.camera_alt_outlined,
          'Camera',
          context,
        ),
        _buildImagePickerButton(
          ImageSource.gallery,
          Icons.image_outlined,
          'Gallery',
          context,
        ),
      ],
    );
  }

  Widget _buildImagePickerButton(
    ImageSource imageSource,
    IconData icon,
    String label,
    BuildContext context,
  ) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon),
            iconSize: 50,
            onPressed: () {
              Navigator.of(context).pop(imageSource);
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
