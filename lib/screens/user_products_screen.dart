import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/edit_product_screen.dart';
import '/widgets/app_drawer.dart';
import '/widgets/user_product_item.dart';
import '/models/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: '',
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          itemBuilder: (_, i) => UserProductItem(
                            productsData.items[i].id!,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
