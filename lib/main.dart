import 'package:al_hussain/providers/searchProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:al_hussain/screens/auth_screen.dart';
import 'package:al_hussain/screens/edit_product_screen.dart';
import 'package:al_hussain/screens/user_products_screen.dart';
import 'package:al_hussain/screens/products_overview_screen.dart';
import 'package:al_hussain/screens/product_detail_screen.dart';

import 'package:parse_server_sdk_flutter/generated/i18n.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Future<void> main()  async {

  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = '39A3ppAzbVWfCA50WqjQasG29PvnB7BCSrgTjedf';
  final keyClientKey = 'sKLUdFsP5Prd1a6wmq350FnVCZctkyBDiffp3QIv';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MaterialApp(
    home:MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Products(token: 'token', userId: 'userId'),),
      ChangeNotifierProvider(create: (_) => searchProvider(),)
      
    ],
    child:  MyApp()),
  ));
  
  
  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Products products;
  late final  user;
  @override
  void initState() {
   // intiUser();
     print("object");
    super.initState();
  }
  Future<void> intiUser () async {
     user = await ParseUser.currentUser() as ParseUser;
     if(user!=null){
       print('token');
      print(user.sessionToken);
      print('id');
      print(user.objectId);
     }
  }

  @override
  Widget build(BuildContext context) {
    bool isLogged = Products.getLogg();
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AL_HUSSAIN',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.pink,
            fontFamily: 'Lato',
          ),
          home: isLogged ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          });
  }
}
