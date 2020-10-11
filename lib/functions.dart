import 'package:brand/widget/constants.dart';

import 'models/product.dart';

// //هذه االأوامر من اجل نقل كل منتج الى الفئة الخاصة به يتصل مع وظائف في صفحة هوم بيج***********
List<Product> getProductByCategory(String kJackets, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KJackets) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}

List<Product> getProductByCategoryTshirt(
    String KTShirt, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KTShirt) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}

List<Product> getProductByCategorySkirt(
    String KSkirt, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KSkirt) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}

List<Product> getProductByCategoryPants(
    String KPants, List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == KPants) {
        products.add(product);
      }
    }
  } catch (e) {
    print(e);
  }

  return products;
}
// //*****************************************************
