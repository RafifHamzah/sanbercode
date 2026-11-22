import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';

class ProductCardShimmer extends StatelessWidget {
  final bool isDark;

  const ProductCardShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark
        ? AppColors.darkSurfaceCard
        : const Color(0xFFE2E8F0);
    final highlightColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF8FAFC);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: Container(color: highlightColor)),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Placeholder(
                          width: double.infinity,
                          height: 14,
                          color: highlightColor,
                        ),
                        const SizedBox(height: 7),
                        _Placeholder(
                          width: 70,
                          height: 12,
                          color: highlightColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Placeholder(
                          width: 82,
                          height: 14,
                          color: highlightColor,
                        ),
                        _Placeholder(
                          width: 30,
                          height: 30,
                          color: highlightColor,
                          radius: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  final bool isDark;

  const ProductGridShimmer({
    super.key,
    this.itemCount = 4,
    required this.isDark,
  }) : assert(itemCount > 0);

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: itemCount,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.68,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemBuilder: (context, index) => ProductCardShimmer(isDark: isDark),
  );
}

class _Placeholder extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double radius;

  const _Placeholder({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
