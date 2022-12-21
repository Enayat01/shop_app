import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/authentication.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
              title: const Text('Welcome!'), automaticallyImplyLeading: false),
          const Divider(),
          buildListTile(
            'Shop',
            Icons.shop_rounded,
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          buildListTile(
            'Orders',
            Icons.payment_rounded,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          buildListTile(
            'Manage Products',
            Icons.edit_note_rounded,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          buildListTile(
            'Logout',
            Icons.logout_rounded,
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Authentication>(context, listen: false).logout();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
