import 'package:flutter/material.dart';
import 'package:al_hussain/models/loading_spinner.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:al_hussain/screens/edit_product_screen.dart';
import 'package:al_hussain/widgets/my_app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/searchProvider.dart';


class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';


  @override
   UserProductsScreenState createState() => UserProductsScreenState();
}

class UserProductsScreenState extends State<UserProductsScreen>{
   
  Future<void> _refreshUserProducts(BuildContext context) async
  {
    print('_refreshUserProducts');
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts()
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Couldn\'t refresh.' ),
        duration: Duration(seconds: 2),
      ));
    });

  }

  void deleteBtnClick(var productsData, BuildContext context, int i){
    //LoadingSpinner(context);
    productsData.removeProduct(productsData.items[i].id,productsData.items[i])
    .then((_){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Student is deleted successfully'),
        duration: Duration(seconds: 2),
      ));
    })
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete'),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
    });
    //Navigator.of(context).pop();
    
    Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }



  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text('Your Students');
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<searchProvider>(builder:(context, value, child) => 
           context.read<searchProvider>().isSearch?TextFormField(
                initialValue: Products.search,
                decoration: InputDecoration(labelText: 'search'),
                textInputAction: TextInputAction.next,
                onChanged: (val){
                  setState(() {
                   Products.search = val; 
                  });
                },
                validator: (val)
                {
                  if(val!.isEmpty){ return 'Please enter a search'; }
                  return null;
                },
              ):Text('Your Students')
      ),
        actions: [
          IconButton(
            onPressed: (){
              if(!context.read<searchProvider>().isSearch){
                print("To search");
                
              } else{
                
                print('To No search');
                Products.search="All";
                }

                context.read<searchProvider>().changeIsSearch();
              
          }
          , icon:Consumer<searchProvider>(builder: (context, value, child) => 
          context.read<searchProvider>().isSearch?Icon(Icons.cancel):
            Icon(Icons.search),)
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){ Navigator.of(context).pushNamed(EditProductScreen.routeName); },
          ),
        ],
      ),
      drawer: MyAppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=> _refreshUserProducts(context),
        color: Colors.white,
        backgroundColor: Colors.teal,
        displacement: 20,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: _refreshUserProducts(context),
            builder: (ctx,snapShot){
              return snapShot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<Products>(
                  builder: (context, productsData, child) => ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        ListTile(
                          title: Text(productsData.items[i].title),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(productsData.items[i].imageUrl),
                            onBackgroundImageError:(o,s) {return;},
                          ),
                          trailing: FittedBox(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    print(productsData.items[i].id);
                                    Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: productsData.items[i].id);
                                  },
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: ()=> deleteBtnClick(productsData, context, i),
                                  color: Theme.of(context).errorColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
            },
          )
        ),
      ),
    );
  }

  }
  

