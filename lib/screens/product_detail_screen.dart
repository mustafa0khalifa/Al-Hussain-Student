import 'package:flutter/material.dart';
import 'package:al_hussain/providers/product.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';

  Map productAssign = {
    'title': '',
    'price': '',
    'description': '',
    'validity':'',
    'category':'',
    'communication':'',
    'quantitative':'',
    'priceBefore30':'',
    'priceBefore15':'',
    'theOtherPrice':'',
    'imageUrl': '',

    
  };

  void intiFromDescription(String tempDescription){
  productAssign['validity'] = tempDescription.split(';')[0];
  productAssign['category'] = tempDescription.split(';')[1];
  productAssign['communication'] = tempDescription.split(';')[2];
  productAssign['quantitative'] = tempDescription.split(';')[3];
  productAssign['priceBefore30'] = tempDescription.split(';')[4];
  productAssign['priceBefore15'] = tempDescription.split(';')[5];
  print('intiFromDescription');

}
  @override
  void initState() {
    
  } 



  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context)!.settings.arguments as String; // is the id!
    final Product loadedProduct = Provider.of<Products>(context,listen: false).items.firstWhere((element) => element.id == productId );
    intiFromDescription(loadedProduct.description);
    return Scaffold(
      appBar: AppBar(
        title: Text( loadedProduct.title ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: false,
            pinned: false,
            automaticallyImplyLeading: false,
            forceElevated: true,
            elevation: 0,
            expandedHeight: 300,
            backgroundColor: Colors.white60,
            flexibleSpace: FlexibleSpaceBar(
              background:Container(
                  alignment: Alignment.center,
                  child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,)
              ),
            ),
          ),
          SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                        child: Text('Description',style: TextStyle(color: Colors.white,fontSize: 25,letterSpacing: 1),),
                        height: 50,
                        color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white38,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(15),
                        child: Text(
                           'validity: ${productAssign['validity']}\n'   
                          'category: ${productAssign['category']}\n'   
                          'communication: ${productAssign['communication']}\n'   
                          'quantitative: ${productAssign['quantitative']}\n'   
                          'Price: ${loadedProduct.price} SPY\n\n'
                          'Favorites: ${loadedProduct.isFavorite ? 'YES' : 'NO'}\n\n',
                          style: TextStyle(color: Colors.black,fontSize: 22),
                        ),
                      ),
                  ),
                    ),
                  ]
                ),
              ),
        ],

      ),
    );
  }
}
