import 'package:brand/models/product.dart';
import 'package:flutter/cupertino.dart';
//هذا الكلاس اساس وظيفة اضافة منتج الى الكارد تستخدم ضمن صفحة (ProductInfo)
class Cartitem extends ChangeNotifier{

  List <Product> products=[];
  addProduct(Product product){
    products.add(product);
    notifyListeners();
  }
  deleteProduct(Product product)async{
    products.remove(product);
    notifyListeners();
  }
}