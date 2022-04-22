import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cartmodel.dart';
import 'cartpage.dart';
import 'home.dart';

void main() => runApp(Grabeat());

class Grabeat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<CartModel>(
      model: CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grabeat',
        home: HomePage(),
        routes: {'/cart': (context) => CartPage()},
      ),
    );
  }
}
