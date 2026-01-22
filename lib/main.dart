import 'package:flutter/material.dart';
import 'package:pokedexg14/pages/pokedex_jhon.dart';
import 'package:pokedexg14/providers/cart_provider.dart';
import 'package:pokedexg14/providers/counter_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const PokedexJhonApp(), // 🔥  
    ),
  );
}
