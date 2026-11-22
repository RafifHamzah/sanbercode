import 'package:e_commerce/app/modules/home/widgets/product_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the requested number of product card placeholders', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProductGridShimmer(itemCount: 4, isDark: false),
          ),
        ),
      ),
    );

    expect(find.byType(ProductCardShimmer), findsNWidgets(4));

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
