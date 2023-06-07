import 'dart:convert';

import 'package:bakalauras/cart_model.dart';
import 'package:bakalauras/container.dart';
import 'package:bakalauras/product.dart';
import 'package:bakalauras/top_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seo/seo_widget.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

Product parseProduct(String responseBody) {
  return Product.fromJson(jsonDecode(responseBody));
}

Future<Product> fetchProduct(Client client, String productId) async {
  final response = await client.get(Uri.parse('https://fakestoreapi.com/products/$productId'));
  return compute(parseProduct, response.body);
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: 'Product details'),
      body: MainContainer(
        child: FutureBuilder<Product>(
          future: fetchProduct(Client(), productId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('An error has occurred!');
            } else if (snapshot.hasData) {
              final product = snapshot.requireData;

              return _ProductDetailScreenItem(product: product);
            } else {
              return const CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}

class _ProductDetailScreenItem extends StatelessWidget {
  const _ProductDetailScreenItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SeoHead(
      title: SeoTitleTag(product.title),
      meta: [
        SeoMetaTag("description", product.description),
      ],
      child: Column(
        children: <Widget>[
          SeoImage(
            src: product.image,
            alt: product.title,
            child: Image(
              image: NetworkImage(product.image),
              height: 300,
            ),
          ),
          SeoText(
            style: SeoTextStyle.h1,
            child: Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SeoText(
            style: SeoTextStyle.h2,
            child: Text(product.category),
          ),
          const SizedBox(height: 15),
          SeoText(
            style: SeoTextStyle.h3,
            child: Text('Rating: ${product.rating.rate}'),
          ),
          SeoText(
            style: SeoTextStyle.h3,
            child: Text('Reviews: ${product.rating.count}'),
          ),
          const SizedBox(height: 15),
          SeoText(
            child: Text(product.description),
          ),
          const SizedBox(height: 30),
          SeoText(
            style: SeoTextStyle.h2,
            child: Text(
              '${product.price} \$',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              var cart = context.read<CartModel>();
              cart.add(product);
            },
            style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.headlineSmall),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Add to cart'),
            ),
          ),
        ],
      ),
    );
  }
}