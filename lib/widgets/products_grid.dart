import 'package:al_hussain/providers/searchProvider.dart';
import 'package:flutter/material.dart';
import 'package:al_hussain/providers/product.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:al_hussain/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid();

  @override
  Widget build(BuildContext context) {
    print('ProductsGrid');

    final products = Provider.of<Products>(context);
    final productsList = context.read<searchProvider>().showFavoritesOnly? products.favoriteItems : products.items;

    return Consumer<Products>(builder: (context, value, child) => 
    GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsList.length,
      itemBuilder: (ctx, i) =>ProductItem(productsList[i]),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    ),);
  }
}
