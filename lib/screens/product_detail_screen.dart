import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: mediaQuery.size.height * 0.4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.black12,
                  child: Text(
                    loadedProduct.title,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: mediaQuery.size.height * 0.05),
                Text(
                  '₹${loadedProduct.price}',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mediaQuery.size.height * 0.05),
                Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                SizedBox(height: mediaQuery.size.height),
              ],
            ),
          )
        ],
      ),
    );
  }
}
