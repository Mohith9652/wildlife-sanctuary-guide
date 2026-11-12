
import 'package:flutter/material.dart';

class ResponsiveNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const ResponsiveNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl,
          width: width ?? double.infinity,
          height: height,
          fit: fit,
          alignment: Alignment.center,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFE8EEE7),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 36,
                color: Color(0xFF54745A),
              ),
            );
          },
        ),
      ),
    );
  }
}
