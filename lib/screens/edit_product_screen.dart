import 'dart:io';

import 'package:flutter/material.dart';
import 'package:al_hussain/models/loading_spinner.dart';
import 'package:al_hussain/providers/product.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map productAssign = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',

    
  };
  Product product = Product(description: '', id: null, price: 0, title: '',imageUrl: "" );
  bool _isInit = true;
  String btnText = 'Add';
  String titleText = 'Add Student';
  bool addMood = true;
  final ImagePicker _picker = ImagePicker();
  late var imageName = "No Image File set Yet !!!";
  PickedFile? pickedFile;
  XFile? image;
  ParseFileBase? parseFile;


  void doubleScreenPopAndMessage(String message){
    Navigator.of(context).pop();
  
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));

    
  }



  void _saveForm(){
    if( !_formKey.currentState!.validate() ){ return; }
    print("product.id :  ");
    print(product.id);
    _formKey.currentState!.save();
    if(product.id == null)
    {
      print("start");
      product = Product(
          id: DateTime.now().toString(),
          title: productAssign['title'],
          description: productAssign['description'],
          price: int.parse(productAssign['price']),
          imageUrl: productAssign['imageUrl'],
          isFavorite: product.isFavorite );
      //LoadingSpinner(context);

      Provider.of<Products>(context, listen: false).addProduct(product,parseFile)
      .then((_){
        doubleScreenPopAndMessage('New Student is added'); })
      .catchError((error){  doubleScreenPopAndMessage('Failed to add new Student');  });

      

    }
    else
    {
      Provider.of<Products>(context, listen: false).editProduct(
          Product(
          id: product.id,
          title: productAssign['title'],
          description: productAssign['description'],
          price: int.parse(productAssign['price']),
          imageUrl: productAssign['imageUrl'],
          isFavorite: product.isFavorite )
      )
      .then((_){ doubleScreenPopAndMessage('saved successfully'); })
      .catchError((error){  doubleScreenPopAndMessage('Failed to edit');  });


      //LoadingSpinner(context);

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    if(_isInit)
    {
      print("didChangeDependencies  start ");
      //String productId = 'null';
      var pId = ModalRoute.of(context)!.settings.arguments;
      print('pID');
      print(pId);
      if(pId != null){
        print("didChangeDependencies  start not null ");
        product = Provider.of<Products>(context).items.firstWhere((element) => element.id == pId);

        productAssign['title'] = product.title;
        productAssign['description'] = product.description;
        productAssign['price'] = product.price.toString();
        productAssign['imageUrl'] = product.imageUrl;

        btnText = 'Save';
        titleText = 'Edait Student';
        addMood = false;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children:[
              TextFormField(
                initialValue: productAssign['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_descriptionFocusNode); },
                onSaved: (val){ productAssign['title'] = val; },
                validator: (val)
                {
                  if(val!.isEmpty){ return 'Please enter a title'; }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                enabled: addMood,
                initialValue: productAssign['description'],
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_priceFocusNode); },
                onSaved: (val){ productAssign['description'] = val; },
              ),
              SizedBox(height: 10,),
              TextFormField(
                initialValue: productAssign['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.number,
                onSaved: (val){ productAssign['price'] = val; },
                validator: (val){
                  if(val!.isEmpty){ return 'Please enter a Price'; }
                  return null;
                },
              ),
              SizedBox(height: 10,),
             GestureDetector(
              child: productAssign['imageUrl'] != '' 
                  ? Container(
                      width: 250,
                      height: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Color.fromARGB(255, 40, 78, 109))),
                      child:Image.network(
                            productAssign['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder:  (context,o,s) {
                            return Center(child: Text('error Photo !!!'));
                          }
                          ),
                          )
                  : Container(
                      width: 250,
                      height: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: Center(
                        child: Text('Click here to pick image from Gallery'),
                      ),
                    ),
              onTap: () async {
                 image = await _picker.pickImage(source: ImageSource.gallery);

                    if(image == null){
                      print('is null ');
                    }
                    else{
                      print("image ..");
                      print(image!.name);
                      parseFile = ParseFile(File(image!.path));
                      final response = await parseFile!.save();
                      if(response.success){
                        print("parseFile!.url ..");
                        print(parseFile!.url);
                        setState((){
                          productAssign['imageUrl']=parseFile!.url;
                          imageName = image!.name;
                        });

                      }
                      else{
                        print("parseFile!.url  Error !!!! ..");
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error selecting the image !!!'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                      
                    }
              },
            ),
              SizedBox(height: 30,),
              ElevatedButton(
                child: Text(btnText,style: TextStyle(fontSize: 18),),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(8))
                ),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
