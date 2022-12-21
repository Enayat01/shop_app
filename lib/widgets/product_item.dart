import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/authentication.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Authentication>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: FittedBox(
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id!, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Added item to the cart!',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
