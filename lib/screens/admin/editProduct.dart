import 'dart:io';
import 'package:brand/models/product.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/custom_widget_image.dart';
import 'package:brand/widget/customtextfield.dart';
import 'package:brand/widget/multiImagePicker.dart';
import 'package:brand/widget/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brand/services/store.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  static String id = 'EditProduct';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  File file;
  List<File> imageList;
  TextEditingController productTitleController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDescController = TextEditingController();
  TextEditingController productCatController = TextEditingController();
  GlobalKey<FormState> _globalkey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalkey,
        appBar: AppBar(
          centerTitle: false,
          title: Text('Add Product'),
          backgroundColor: KMainColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton.icon(
                color: Colors.green,
                onPressed: () {
                  pickImage();
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  'Image',
                  style: (TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            )
          ],
        ),
        backgroundColor: KMainColor,
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            CustomWidgetImage(
              image: 'images/icons/buy.png',
              titel: 'Brand way',
            ),
            ////****this from widget multimImagePicker******///////
            MultiImagePickterLis(
                imageList: imageList,
                removeNewImage: (index) {
                  return removeimage(index);
                }),
            SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ProductTextField(
                    textTitle: 'Product Title',
                    textHint: 'Enter Product Title ',
                    controller: productTitleController),
                SizedBox(
                  height: 10.0,
                ),
                ProductTextField(
                    textTitle: 'Products price',
                    textHint: 'Enter Products price ',
                    controller: productPriceController),
                SizedBox(
                  height: 10.0,
                ),
                ProductTextField(
                    textTitle: 'Description Title',
                    textHint: 'Enter Product Description',
                    controller: productDescController,
                    maxLines: 4,
                    height: 130),
                SizedBox(
                  height: 10.0,
                ),
                ProductTextField(
                  textTitle: 'Category Title',
                  textHint: 'Enter Product Category',
                  controller: productCatController,
                  maxLines: 4,
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 25.0,
                ),
                Builder(
                  builder: (context) => RaisedButton(
                    color: Colors.green,
                    child: Text('Add Product'),
                    onPressed: () {
                      addNewProdect(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ));
  }

//this method for take image from gallrey
  void pickImage() async {
    // ignore: deprecated_member_use
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      List<File> imageFile = List();
      imageFile.add(file);
      if (imageList == null) {
        imageList = List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {});
    }
  }

//this methoed for delet image from pick
  removeimage(int index) async {
    imageList.removeAt(index);
    setState(() {});
  }

  addNewProdect(BuildContext context) async {
    if (imageList == null || imageList.isEmpty) {
      // ignore: unnecessary_statements
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('image cannot be empty'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // ignore: unrelated_type_equality_checks
    if (productTitleController.text == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('title cannot be empty'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // ignore: unrelated_type_equality_checks
    if (productPriceController.text == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('price cannot be empty'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // ignore: unrelated_type_equality_checks
    if (productDescController.text == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('description cannot be empty'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (productCatController.text == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('category cannot be empty'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // try {
    //   if (KProductCategory == 'welcome ') {
    //     return _store.loadProducts();
    //   }
    //
    //
    //   if (KProductCategory == 'jackets') {
    //     return _store.loadProductsJackets();
    //
    //   }
    //   if (KProductCategory == 'skirt') {
    //     return _store.loadProductsSkirt();
    //   }
    //   if (KProductCategory == 'T_shirt') {
    //     return _store.loadProductsT_Shirt();
    //   }
    //   if (KProductCategory == 'pants') {
    //     return _store.loadProductsPants();
    //   }
    // } catch (e) {
    //   e.toString();
    // }

    displayProgressDailog(context);
    Map<String, dynamic> newProduct = {
      KProductName: productTitleController.text,
      KProductPrice: productPriceController.text,
      KProductDescription: productDescController.text,
      KProductCategory: productCatController.text,
    };

    String productID = await _store.addNewProduct(newProduct: newProduct);





//    //****************** +add image to firebase***************************
    List<String> imagesURL = await _store.uploadProductImage(
        docID: productID ,
        imageList: imageList);
    if (imagesURL.contains(error)) {
      closeProgressDailog(context);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('image upload error call developer'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // +this method if upload is right will update and add image and imfo
    bool result =
        await _store.updateProductImages(docID: productID, data: imagesURL);
    if (result != null && result == true) {
      closeProgressDailog(context);
      resetEveryThing();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Product added is don'),
        backgroundColor: Colors.green,
      ));
    } else {
      closeProgressDailog(context);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Product added Faild'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void resetEveryThing() {
    imageList.clear();
    productTitleController.text = '';
    productPriceController.text = '';
    productDescController.text = '';
    productCatController.text = '';
  }
}
