import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart' show Cart;
import '../models/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('₹${cart.totalAmount}'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (widget.cart.totalAmount > 0 || _isLoading) {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount,
          );
          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Empty Cart!',
                style: TextStyle(fontSize: 25),
              ),
              content: const Text(
                  'Your cart is empty, first add something to the cart.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
              elevation: 15,
            ),
          );
        }
      },
      child: _isLoading
          ? CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            )
          : const Text('ORDER NOW'),
    );
  }
}
