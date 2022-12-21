import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/orders.dart' as odr;

class OrderItem extends StatefulWidget {
  final odr.OrderItem order;

  const OrderItem({
    required this.order,
    super.key,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height:
          _expanded ? min(widget.order.products.length * 20 + 130, 210) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('${widget.order.amount}'),
              subtitle: Text(
                DateFormat().format(widget.order.datetime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              height: _expanded
                  ? min(widget.order.products.length * 20 + 15, 120)
                  : 0,
              duration: const Duration(milliseconds: 400),
              child: ListView(
                children: widget.order.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${product.quantity}x ₹${product.price}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
