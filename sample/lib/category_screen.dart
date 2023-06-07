import 'dart:convert';
import 'dart:math';

import 'package:bakalauras/container.dart';
import 'package:bakalauras/extensions.dart';
import 'package:bakalauras/top_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seo/seo_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

List<String> parseCategories(String responseBody) {
  return (jsonDecode(responseBody) as List<dynamic>).cast<String>();
}

Future<List<String>> fetchCategories(Client client) async {
  final response = await client.get(Uri.parse('https://fakestoreapi.com/products/categories'));
  return compute(parseCategories, response.body);
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall;

    return SeoHead(
      title: SeoTitleTag("Bakalauras seo e-commerce prototype"),
      meta: [
        SeoMetaTag("description", "E-commerce prototype testing seo capabilities using Flutter technology"),
      ],
      child: Scaffold(
        appBar: const TopBar(title: 'E-commerce Prototype'),
        body: MainContainer(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SeoText(
                  child: Text(
                    'Please choose product category:',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),
              _CategoryListWidget(),
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
              SliverToBoxAdapter(
                child: ElevatedButton(
                  onPressed: () => context.go("/products"),
                  style: ElevatedButton.styleFrom(textStyle: textStyle),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SeoLink(
                      href: "/products",
                      child: Text('All products'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryListWidget extends StatelessWidget {
  _CategoryListWidget({Key? key}) : super(key: key);

  final random = Random();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchCategories(Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('An error has occurred!'),
            ),
          );
        } else if (snapshot.hasData) {
          final categories = snapshot.requireData;

          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return _CategoryListItemWidget(random, categories[index]);
              },
              childCount: categories.length,
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class _CategoryListItemWidget extends StatelessWidget {
  const _CategoryListItemWidget(this.random, this.category, {Key? key}) : super(key: key);

  final Random random;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.primaries[random.nextInt(Colors.primaries.length)],
      child: InkWell(
        splashColor: Colors.blue.withAlpha(10),
        onTap: () => context.go(Uri(path: '/products', queryParameters: {"category": category}).toString()),
        child: Center(
          child: SeoLink(
            href: Uri(path: '/products', queryParameters: {"category": category}).toString(),
            child: Text(
              category.capitalize(),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}