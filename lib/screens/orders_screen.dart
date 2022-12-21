import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapShot) {
          //Checking for waiting state and showing a loading indicator
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }
          //Error check
          else if (dataSnapShot.error != null) {
            return const Center(
              child: Text('An error occurred!'),
            );
          } else {
            //Building user orders list
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i]),
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
      ),
    );
  }
}
