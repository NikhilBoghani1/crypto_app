import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingContainer extends StatelessWidget {
  final double? width;
  final double? hight;

  const LoadingContainer({super.key, required this.width, required this.hight,});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Container(
        width: width,
        height: hight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.8),
        ),
      ),
    );
  }
}
