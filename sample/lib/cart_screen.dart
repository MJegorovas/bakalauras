import 'package:bakalauras/cart_model.dart';
import 'package:bakalauras/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MainContainer(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartListWidget(cart: cart),
              ),
            ),
          ),
          const Divider(height: 4, color: Colors.black),
          _CartTotalWidget(cart: cart),
        ],
      ),
    );
  }
}

class _CartListWidget extends StatelessWidget {
  const _CartListWidget({super.key, required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.products.length,
      itemBuilder: (context, index) => ListTile(
        leading: Image(
          image: NetworkImage(cart.products[index].image),
          height: 56,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            cart.remove(cart.products[index]);
          },
        ),
        title: Text(cart.products[index].title),
      ),
    );
  }
}

class _CartTotalWidget extends StatelessWidget {
  const _CartTotalWidget({super.key, required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartModel>(
              builder: (context, cart, child) => Text('\$${cart.totalPrice}'),
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: cart.products.isNotEmpty ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Buying not supported yet.'),
                  ),
                );
              } : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('BUY'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}