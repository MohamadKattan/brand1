import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




const KUnActivedColor = Colors.blueGrey;
const KMainColor = Colors.orange;
const KScondaryColor = Colors.white;


//******

const KAuthCollection='user';
const KuserCartList='userCart';
const KUid='uid';
const KName='name';
const KEmail='email';
const KUrl='url';



//*************

const KProductCollection = 'Products';
const KProductName = 'ProductName';
const KProductPrice = 'ProductPrice';
const KProductDescription = 'ProductDescription';
const KProductCategory = 'ProductCategory';
const  KProductImage = 'KProductImage';
//*****************
const KJackets = 'jacket';
const KTShirt = 'tShirt';
const KSkirt = 'skirt';
const KPants = 'pant';

//****************
const KOrders = 'Orders';
const KOrderDetails = 'OrderDetails';
const KTotalPrice = 'TotalPrice';
const KAddress = 'Address';
const kemail='email';
const kname='name';
const KProductQuantity = 'ProductQuantity';
//******************
const KKeepMeloggedIN='KeepMeloggedIN';
const KCardsCollection='Cards';
const Ktokens='tokens';
const kNotfction='Notfction';
const String Kdevtoken='deviceNotfction';
const String error = 'error';

//*************
const String KuserImageProfail='userImageProfail';

class EcommercApp{
  static FirebaseAuth auth;
  static FirebaseUser user;
  static Firestore firestore;
  static SharedPreferences sharedPreferences;
}
