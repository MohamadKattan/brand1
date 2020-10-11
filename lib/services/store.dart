// هذا الكلاس يقوم بإرسال واستقبال بينات من والى ديتى بيز
import 'dart:io';
import 'package:brand/models/product.dart';
import 'package:brand/provider/cartItemCounter.dart';
import 'package:brand/screens/users/productInfo.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Store {
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage fs = FirebaseStorage.instance;

  @override
  // for add product to firestore and it is took information from product
  // ignore: non_constant_identifier_names
  Future<String> addNewProduct({Map newProduct}) async {
    String documentID;
    await _firestore
        .collection(KProductCollection)
        .add(newProduct)
        .then((documentRef) => documentID = documentRef.documentID);
    return documentID;
// TODO: implement addPRoduct
  }

//for upload image to storage
  @override
  // ignore: missing_return
  Future<List<String>> uploadProductImage({
    List<File> imageList,
    String docID,
  }) async {
    // TODO: implement uploadProductImage
    List<String> imagesUrl = List();
//   String imageUrl;

    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(KProductCollection)
            .child(docID)
            .child(docID + '$s.jpg');

        StorageUploadTask uploadTask = storageReference.putFile((imageList[s]));
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        imagesUrl.add(downloadUrl.toString());
      }
    } on PlatformException catch (e) {
      imagesUrl.add(error);
      print(e.details);
    }
    return imagesUrl;
  }

//this methoed for update prodect inside app
  @override
  Future<bool> updateProductImages({String docID, List<String> data}) async {
    // TODO: implement updateProductImage
    bool msg;
    await _firestore
        .collection(KProductCollection)
        .document(docID)
        .updateData({KProductImage: data}).whenComplete(() => msg = true);
    return msg;
  }

  //this method for download from fire base to app by snapShot to homepage
  Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection(KProductCollection).snapshots();
  }

//this method to up load order to firebase
  storeOrders(data, List<Product> products) {
    FirebaseAuth.instance.currentUser().then((user) {
      var documentRef =
          Firestore.instance.collection(KOrders).document(user.uid);
      documentRef.setData(data);
      for (var product in products) {
        documentRef.collection(KOrderDetails).document().setData({
          KProductName: product.pName,
          KProductPrice: product.pPrice,
          KProductImage: product.pimage,
          KProductQuantity: product.pquantity
        });
      }
    });

  }

  // this method to download oreder from firebase to app
  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(KOrders).snapshots();
  }

  // this method for download order detels
  Stream<QuerySnapshot> loadOrdersDetails(documentId) {
    return _firestore
        .collection(KOrders)
        .document(documentId)
        .collection(KOrderDetails)
        .snapshots();
  }

//this method for delete prodect from firestore && imageprodect from strage
// home page && fake homePAGE && mangment page
  deleteProduct(docmentId, pimage) async {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(pimage);
    print(storageReference.path);
    await storageReference.delete();
    print('image deleted');
    await _firestore
        .collection(KProductCollection)
        .document(docmentId)
        .delete();
  }

//this for edit
  editProduct(data, docmentId) {
    _firestore
        .collection(KProductCollection)
        .document(docmentId)
        .updateData(data);
  }

// this for get dev token and download on firestore
  getDevToken(deviceToken) {
    FirebaseAuth.instance.currentUser().then((user) {
      var documentRef =
          Firestore.instance.collection(Kdevtoken).document(user.uid);
      documentRef.setData({'deviceToken': deviceToken});
    });
  }

  removeItemFromFireStore(productID,BuildContext context){
    List tempCarList =
    EcommercApp.sharedPreferences.getStringList(KuserCartList);
    tempCarList.remove(productID);
    EcommercApp.firestore
        .collection(KAuthCollection)
        .document(EcommercApp.sharedPreferences.getString(KUid))
        .updateData({KuserCartList: tempCarList}).then((value) {
      EcommercApp.sharedPreferences.setStringList(KuserCartList, tempCarList);

    });

  }
}
