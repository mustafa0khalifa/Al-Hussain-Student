import 'package:flutter/material.dart';
import 'package:al_hussain/main.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:al_hussain/screens/products_overview_screen.dart';
import 'package:al_hussain/screens/user_products_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class MyAppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar( title: Text('Where To Go!'),),
          Divider(height: 5,thickness: 3,color: Colors.pink[100],),
          ListTile(leading: Icon(Icons.shop_two),title: Text('Students'),onTap: (){Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName,);},),
          Divider(height: 5,thickness: 3,color: Colors.pink[100],),
          ListTile(leading: Icon(Icons.edit_outlined),title: Text('MANGE Students'),onTap: (){Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);},),
          Divider(height: 5,thickness: 3,color:Colors.pink[100]),
          Spacer(),
          Divider(height: 5,thickness: 3,color:Colors.pink[100]),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LOGOUT'),
            onTap: () async {
              Products.setLogg(false);
              final user = await ParseUser.currentUser() as ParseUser;
              var response = await user.logout();

              if (response.success) {
                print("Log Out Ok");
              } else {
                print("Log Out Error");
              }
              Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder:(_)=>MyApp()), (route) => false);
            },
          ),
          Divider(height: 5,thickness: 3,color:Colors.pink[100]),
          SizedBox(height: 5,)
        ],
      ),
    );
  }
}
