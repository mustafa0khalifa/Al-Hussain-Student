/////////finish


import 'package:flutter/material.dart';
import 'package:al_hussain/providers/products.dart';
import 'package:al_hussain/screens/products_overview_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:[ Colors.tealAccent, Colors.pinkAccent ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 1],
              ),
            ),
          ),
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-0.14)..translate(-8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pink.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.pinkAccent,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'AL_HUSSAIN',
                      style: TextStyle(
                        color: Theme.of(context).accentTextTheme.headline6!.color,
                        fontSize: 25,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget
{
   @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': '',};
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void alert(String message)
  {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Error Occurred'),
          content: Text(message),
          actions: [TextButton(child:Text('ok'), onPressed: (){ Navigator.of(context).pop();},),],
        );
      }
    );
  }

  void _submit() async
  {
    if ( !_formKey.currentState!.validate() ){ return; }
    _formKey.currentState!.save();

    if (_authMode == AuthMode.Login){
      final username =  _authData['email'];
      final password =  _authData['password'];

      final user = ParseUser(username, password, null);

      var response = await user.login();

      if (response.success) {
        Products.setLogg(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login Ok ..."),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName,);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login Error !!!"),
          duration: Duration(seconds: 2),
        ));
      }

    }else{
      alert("You cannot create an account at the moment!!!");
    }


          
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login){  setState((){ _authMode = AuthMode.Signup; });  }
    else{  setState((){ _authMode = AuthMode.Login; });  }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail',),
                  keyboardType: TextInputType.emailAddress,
                  validator:(value)
                  {
                    if( value!.isEmpty || !value.contains('@') ){ return 'Invalid email!'; }
                    return null;
                  },
                  onSaved: (value){ _authData['email'] = value!; },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator:(value)
                  {
                    if( value!.isEmpty || value.length < 5 ){ return 'Password is too short!'; }
                    return null;
                  },
                  onSaved: (value){ _authData['password'] = value!; },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),

                FlatButton(
                  child:
                      Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button!.color,
                ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
