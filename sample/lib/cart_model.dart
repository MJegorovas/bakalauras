import 'dart:collection';

import 'package:bakalauras/product.dart';
import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _products = [];

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  double get totalPrice => _products.fold(0, (previousValue, element) => previousValue + element.price);

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void removeAll() {
    _products.clear();
    notifyListeners();
  }
}