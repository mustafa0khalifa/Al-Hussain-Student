import 'package:al_hussain/providers/searchProvider.dart';
import 'package:flutter/material.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:al_hussain/widgets/my_app_drawer.dart';
import 'package:al_hussain/widgets/products_grid.dart';
import 'package:provider/provider.dart';


enum menuSelectionOptions{
  All,
  Favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/ProductsOverviewScreen-products';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  Future<void> fetchAndSetData() async
  {
    await context.read<Products>().fetchAndSetProducts();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    print('ProductsOverviewScreen');

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
              ):Text('AL_HUSSAIN')
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
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            itemBuilder: (_)=>[
              PopupMenuItem(child: Text('Show All'),value: menuSelectionOptions.All,),
              PopupMenuItem(child: Text('Show Favorites'),value: menuSelectionOptions.Favorites,),
            ],
            onSelected: (menuSelectionOptions option){
              setState(() {
                if(option == menuSelectionOptions.Favorites){ context.read<searchProvider>().okShowFavoritesOnly(); }
                else{ context.read<searchProvider>().unShowFavoritesOnly(); }
              });
            },
          ),
        ],
      ),
      drawer: MyAppDrawer(),
      body:ProductsGrid()
    );
  }
}
