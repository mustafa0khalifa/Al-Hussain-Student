
import 'package:flutter/cupertino.dart';

class searchProvider extends ChangeNotifier{
  bool _isSearch = false;
  bool _showFavoritesOnly = false;


  bool get isSearch =>_isSearch;

  bool get showFavoritesOnly =>_showFavoritesOnly;

  void changeIsSearch(){
    this._isSearch = ! this.isSearch;
    notifyListeners();
  }

   void okShowFavoritesOnly(){
    this._showFavoritesOnly = true;
    notifyListeners();
  }

  void unShowFavoritesOnly(){
    this._showFavoritesOnly = false;
    notifyListeners();
  }

}