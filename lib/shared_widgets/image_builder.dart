import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../repositories/image_repository.dart';

class ImageBuilder extends StatelessWidget {
  ImageBuilder({
    required this.imagePath,
    required this.height,
    this.width,
    this.errorWidget,
  });

  final String imagePath;
  final Widget? errorWidget;
  final double height;
  final double? width;

  final _imageRepository = getIt.get<ImageRepository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(imagePath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.network(
              snapshot.data ?? '',
              fit: BoxFit.cover,
              height: height,
              width: width ?? height,
              loadingBuilder: (context, child, chunk) {
                if (chunk == null) {
                  return child;
                }
                return _buildLoadingImage();
              },
              errorBuilder: (context, object, stacktrace) {
                return errorWidget ??
                    Icon(
                      Icons.person_outline_rounded,
                      size: height,
                    );
              },
            );
          } else {
            return _buildLoadingImage();
          }
        });
  }

  Widget _buildLoadingImage() {
    return SizedBox(
      height: height,
      width: width ?? height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
