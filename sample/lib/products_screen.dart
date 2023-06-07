import 'dart:convert';

import 'package:bakalauras/container.dart';
import 'package:bakalauras/product.dart';
import 'package:bakalauras/top_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seo/seo_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

List<Product> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> fetchProducts(Client client, String? category) async {
  String url = 'https://fakestoreapi.com/products';
  if (category != null) {
    url += '/category/$category';
  }

  final response = await client.get(Uri.parse(url));
  return compute(parseProducts, response.body);
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key, required this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    return SeoHead(
      title: SeoTitleTag("Products List"),
      meta: [
        SeoMetaTag("description", "Show all available items that belong to ${category == null ? "all categories" : "$category category"}"),
      ],
      child: Scaffold(
        appBar: const TopBar(title: 'Products'),
        body: MainContainer(
          child: FutureBuilder<List<Product>>(
            future: fetchProducts(Client(), category),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return _ProductsListWidget(products: snapshot.requireData);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ProductsListWidget extends StatelessWidget {
  const _ProductsListWidget({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return _ProductsListItemWidget(product: products[index]);
      },
    );
  }
}

class _ProductsListItemWidget extends StatelessWidget {
  const _ProductsListItemWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => context.go("/products/${product.id}"),
        child: ListTile(
          leading: SeoImage(
            src: product.image,
            alt: product.title,
            child: Image(
              image: NetworkImage(product.image),
              height: 56,
            ),
          ),
          title: SeoLink(
            href: "/products/${product.id}",
            child: Text(product.title),
          ),
          subtitle: SeoText(
            child: Text('${product.price} \$'),
          ),
        ),
      ),
    );
  }
}