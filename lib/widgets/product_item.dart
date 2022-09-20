import 'package:flutter/material.dart';
import 'package:al_hussain/providers/product.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  ProductItem( this.product); 
  final product ;
  @override
  Widget build(BuildContext context) {
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder:  (context,o,s) {
             return Center(child: Text('No Photo'));
           }
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: product.isFavorite? Icon(Icons.favorite):Icon(Icons.favorite_border_outlined),
            color: Theme.of(context).accentColor,
            onPressed:()
            {
              Provider.of<Products>(context, listen: false).toggleFavoriteForProduct(product)
              .catchError((error)
              {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: product.isFavorite? Text('Failed to remove from favorites') : Text('Failed to add to favorites'),
                  duration: Duration(seconds: 1), ));
              });
            },
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              Text(
                product.price.toString(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
