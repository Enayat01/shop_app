import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  const ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItem : productsData.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        // create: (context) => products[i],
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
    );
  }
}
