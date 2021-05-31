import 'package:flutter/material.dart';

import '../dependency_injection_container.dart';
import '../repositories/image_repository.dart';

class CircleImage extends StatelessWidget {
  CircleImage({
    required this.imagePath,
    required this.height,
    this.errorWidget,
  });

  final String imagePath;
  final Widget? errorWidget;
  final double height;

  final _imageRepository = getIt.get<ImageRepository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageRepository.getImageUrlForImagePath(imagePath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: Image.network(
                  snapshot.data ?? '',
                  fit: BoxFit.cover,
                  height: height,
                  width: height,
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
                ));
          } else {
            return _buildLoadingImage();
          }
        });
  }

  Widget _buildLoadingImage() {
    return SizedBox(
      height: height,
      width: height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
