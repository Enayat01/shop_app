import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';

import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '/screens/cart_screen.dart';
import '../models/cart.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // const ProductsOverviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (int selectedValue) {
              setState(() {
                if (selectedValue == 0) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 0, child: Text('Favorites')),
              const PopupMenuItem(value: 1, child: Text('View All')),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, chld) => Badge(
              animationType: BadgeAnimationType.slide,
              badgeColor: Theme.of(context).colorScheme.secondary,
              showBadge: cart.itemCount > 0 ? true : false,
              position: BadgePosition.topEnd(top: -3, end: 3),
              padding: const EdgeInsets.all(3),
              badgeContent: Text(
                cart.itemCount.toString(),
              ),
              child: chld,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : ProductsGrid(_showFavorites),
    );
  }
}
