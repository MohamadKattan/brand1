//هذا الكلاس حاوي بيانات البرودكت الواحد الذي سوف نقوم بإرساله الى ادد برودكيت في كلاس ال ستور
class Product {
  String pName;
String pPrice;
  String pDescription;
  String pCategory;
  String pID;
  int pquantity;
List<dynamic>pimage;


  Product(
      {this.pCategory,
      this.pDescription,
      this.pName,
      this.pPrice,
      this.pID,
      this.pquantity,
      this.pimage,
     });
}
