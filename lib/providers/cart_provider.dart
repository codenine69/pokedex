import 'package:flutter/material.dart';
import 'package:pokedexg14/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);

  double get total => _items.fold(0, (sum, item) => sum + item.price);

  void add(ProductModel p) {
    _items.add(p);
    notifyListeners();
  }

  void remove(ProductModel p) {
    _items.remove(p);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
