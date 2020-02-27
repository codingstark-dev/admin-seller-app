import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/FormDetailsUSer/bankdetails.dart';
import 'package:sellerapp/Screen/widget/formerror.dart';
import 'package:sellerapp/model/db/brand.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellerapp/model/db/category.dart';
import 'package:sellerapp/model/db/product.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/notifier/service_locator.dart';
import 'package:sellerapp/service/streamfiles.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Color black = Colors.black;
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  Color grey = Colors.grey;
  bool isLoading = false;
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDesController = TextEditingController();
  final TextEditingController productPromoController = TextEditingController();
  final TextEditingController productPromoDicountController =
      TextEditingController();
  final TextEditingController customUnitController = TextEditingController();
  ProductService productService = ProductService();
  final TextEditingController quatityController = TextEditingController();
  final TextEditingController originalPriceController = TextEditingController();
  Color active = Colors.deepPurple[400];
  List<String> selectedSizes = <String>[];
  Color white = Colors.white;

  // BrandService _brandService = BrandService();
  // CategoryService _categoryService = CategoryService();
  String _currentBrand;
  String _currentCategory;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image1;
  File _image2;
  File _image3;
  String imageurl1;
  String imageurl2;
  String imageurl3;
  List<String> imageurl = [];
  List<String> promocode = [];
  List<String> promoprice = [];
  var category;
  var brand;
  bool _visible = false;

  String _sizetext = "Add Size (Optional)";
  String _promotext = "Create Promocode (Optional)";

  bool _textfielddes = false;

  var _currentSelectedValue;

  var units;

  bool _unitcustom = false;

  var _brandSelectedValue;

  var _categorySelectedValue;

  int get sellingPrice => int.parse(sellingPriceController.text);
  int get orginalPrice => int.parse(originalPriceController.text);

  // List<DropdownMenuItem<String>> getCategoriesDropdown() {
  //   List<DropdownMenuItem<String>> items = new List();
  //   for (int i = 0; i < categories.length; i++) {
  //     setState(() {
  //       items.insert(
  //           0,
  //           DropdownMenuItem(
  //               child: Text(categories[i].data['category']),
  //               value: categories[i].data['category']));
  //     });
  //   }
  //   return items;
  // }

  // List<DropdownMenuItem<String>> getBrandosDropDown() {
  //   List<DropdownMenuItem<String>> items = new List();
  //   for (int i = 0; i < brands.length; i++) {
  //     setState(() {
  //       items.insert(
  //           0,
  //           DropdownMenuItem(
  //               child: Text(brands[i].data['brand']),
  //               value: brands[i].data['brand']));
  //     });
  //   }
  //   return items;
  // }

  GlobalKey<FormState> _brandFormKey = GlobalKey();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  TextEditingController brandController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  // _getCategories() async {
  //   List<DocumentSnapshot> data = await _categoryService.getCategories();
  //   print(data.length);
  //   setState(() {
  //     categories = data;
  //     categoriesDropDown = getCategoriesDropdown();
  //     _currentCategory = categories[0].data['category'];
  //   });
  // }

  // _getBrands() async {
  //   List<DocumentSnapshot> data = await _brandService.getBrands();
  //   print(data.length);
  //   setState(() {
  //     brands = data;
  //     brandsDropDown = getBrandosDropDown();
  //     _currentBrand = brands[0].data['brand'];
  //   });
  // }

  // changeSelectedCategory(String selectedCategory) {
  //   setState(() => _currentCategory = selectedCategory);
  // }

  // changeSelectedBrand(String selectedBrand) {
  //   setState(() => _currentBrand = selectedBrand);
  // }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
      case 2:
        setState(() => _image2 = tempImg);
        break;
      case 3:
        setState(() => _image3 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload(
      String username, String uid, String catergoryUpload) async {
    var id = Uuid().v1();
    try {
      if (_categorySelectedValue != null) {
        if (units != null || customUnitController.text.isNotEmpty) {
          if (_formKey.currentState.validate()) {
            setState(() => isLoading = true);
            if (_image1 != null && _image2 != null && _image3 != null) {
              String imageUrl1;
              String imageUrl2;
              String imageUrl3;

              final FirebaseStorage storage = FirebaseStorage.instance;
              final String picture1 = "1${id.substring(0, 8)}.jpg";
              StorageUploadTask task1 = storage
                  .ref()
                  .child(uid)
                  .child(productNameController.text)
                  .child(picture1)
                  .putFile(_image1);
              final String picture2 = "2${id.substring(0, 8)}.jpg";
              StorageUploadTask task2 = storage
                  .ref()
                  .child(uid)
                  .child(productNameController.text)
                  .child(picture2)
                  .putFile(_image2);
              final String picture3 = "3${id.substring(0, 8)}.jpg";
              StorageUploadTask task3 = storage
                  .ref()
                  .child(uid)
                  .child(productNameController.text)
                  .child(picture3)
                  .putFile(_image3);
              setState(() {
                imageurl.add(picture1);
                imageurl.add(picture2);
                imageurl.add(picture3);
              });
              StorageTaskSnapshot snapshot1 =
                  await task1.onComplete.then((snapshot) => snapshot);
              StorageTaskSnapshot snapshot2 =
                  await task2.onComplete.then((snapshot) => snapshot);

              task3.onComplete.then((snapshot3) async {
                imageUrl1 = await snapshot1.ref.getDownloadURL();
                imageUrl2 = await snapshot2.ref.getDownloadURL();
                imageUrl3 = await snapshot3.ref.getDownloadURL();
                List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];
                List<String> spiltList = productNameController.text.split(" ");
                List<String> indexList = [];
                String productIds = Uuid().v4().substring(0, 6);

                //! making search

                for (var i = 0; i < spiltList.length; i++) {
                  for (var y = 1; y < spiltList[i].length + 1; y++) {
                    indexList.add(spiltList[i].substring(0, y).toLowerCase());
                  }
                }
                final String fcm = await FirebaseMessaging().getToken();
                sl.get<ProductService>().uploadProduct(
                    {
                      "Product Description": productDesController.text,
                      "indexList": indexList,
                      "ProductUnit": (units == "Custom")
                          ? customUnitController.text.toString()
                          : units,
                      "ProductReview": false,
                      "UserService": catergoryUpload,
                      "Featured Product": false,
                      "ProductName": productNameController.text,
                      "UploaderName": username,
                      "price": double.parse(sellingPriceController.text),
                      "Orignal Price": int.parse(originalPriceController.text),
                      "sizes": selectedSizes.isEmpty ? "" : selectedSizes,
                      "images": imageList,
                      "quantity": int.parse(quatityController.text),
                      "brand": _brandSelectedValue ?? "",
                      "Discount":
                          (orginalPrice - sellingPrice) / orginalPrice * 100,
                      "category": _categorySelectedValue,
                      "Reference": productIds,
                      "TimeStamp": Timestamp.now(),
                      "Token": fcm,
                      "ImageDes": imageurl,
                      "Promocode": (promocode.isEmpty) ? "" : promocode[0],
                      "PromoPrice": (promoprice.isEmpty) ? "" : promoprice[0],
                    },
                    username,
                    {
                      "uid": uid,
                      "Promocode": (promocode.isEmpty) ? "" : promocode[0],
                      "PromoPrice": (promoprice.isEmpty) ? "" : promoprice[0],
                      "Token": fcm,
                      "category": category,
                      "brand": brand ?? "",
                      "ProductName": productNameController.text,
                    });
                // productService.uploadProduct({
                //   "indexList": indexList,
                //   "ProductReview": false,
                //   "ProductName": productNameController.text,
                //   "UploaderName": username,
                //   "price": double.parse(sellingPriceController.text),
                //   "Orignal Price": int.parse(originalPriceController.text),
                //   "sizes": selectedSizes,
                //   "images": imageList,
                //   "quantity": int.parse(quatityController.text),
                //   "brand": _currentBrand,
                //   "Discount":
                //       (orginalPrice - sellingPrice) / orginalPrice * 100,
                //   "category": _currentCategory,
                //   "Reference": productIds,
                //   "TimeStamp": Timestamp.now(),
                //   "Token": fcm,
                //   "ImageDes": imageurl,
                //   "ProductDes": productDesController.text
                // }, username);
                _formKey.currentState.reset();
                setState(() => isLoading = false);
                Fluttertoast.showToast(msg: 'Product added');
                Navigator.pop(context);
              });
            } else {
              setState(() => isLoading = false);

              Fluttertoast.showToast(msg: 'select atleast one size');
            }
          } else {
            setState(() => isLoading = false);
            Fluttertoast.showToast(msg: 'All The Images Must Be Provided');
          }
        } else {
          Fluttertoast.showToast(msg: "Please Add Proper Units");
        }
      } else {
        Fluttertoast.showToast(msg: "Please Select Category");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // _getCategories();
    // _getBrands();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var _currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final db = DatabaseService(uid: user?.uid);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        )
        // Icon(
        //   Icons.close,
        //   color: black,
        // )
        ,
        brightness: Brightness.light,
        title: Text(
          "Add Product",
          style: TextStyle(color: black),
        ),
      ),
      body: StreamBuilder<UserDetails>(
          stream: db?.documentSnapshot,
          builder: (context, snapshot) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: <Widget>[
                          FormDetailNotifications(
                            title: "Important Notice!",
                            message:
                                "Please Add Your Bank Details. To Add Products!",
                            buttonTile: "Add Details",
                            buttonFuc: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BankDetailsSubmit()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Remember Star Marks (*) Always Importants',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 12),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select The Clear And Proper Images *',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 12),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlineButton(
                                      borderSide: BorderSide(
                                          color: grey.withOpacity(0.5),
                                          width: 2.5),
                                      onPressed: () {
                                        _selectImage(
                                            ImagePicker.pickImage(
                                                source: ImageSource.gallery,),
                                            1);
                                      },
                                      child: _displayChild1()),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlineButton(
                                      borderSide: BorderSide(
                                          color: grey.withOpacity(0.5),
                                          width: 2.5),
                                      onPressed: () {
                                        _selectImage(
                                            ImagePicker.pickImage(
                                                source: ImageSource.gallery),
                                            2);
                                      },
                                      child: _displayChild2()),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                        color: grey.withOpacity(0.5),
                                        width: 2.5),
                                    onPressed: () {
                                      _selectImage(
                                          ImagePicker.pickImage(
                                              source: ImageSource.gallery),
                                          3);
                                    },
                                    child: _displayChild3(),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Enter Full Product Name And Fill Properly',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 12),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            width: 350,
                            child: FlatButton.icon(
                                textColor: active,
                                onPressed: () {
                                  _brandAlert(context, user.uid);
                                },
                                icon: Icon(Icons.add_circle),
                                label: Text("Add Brand")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection("Grocery")
                                    .snapshots(),
                                builder: (context, dropbt) {
                                  if (!dropbt.hasData ||
                                      dropbt.data.documents.length == 0) {
                                    return Text(
                                      "No Catergory Added",
                                    );
                                  }
                                  return FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16.0),
                                            hintText: 'Select Category',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        isEmpty: _categorySelectedValue == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: Text("Select Category"),
                                            value: _categorySelectedValue,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _categorySelectedValue =
                                                    newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: dropbt.data != null
                                                ? dropbt.data.documents
                                                    .map((f) {
                                                    return DropdownMenuItem(
                                                      value: f.documentID
                                                          .toString(),
                                                      child: Text(f.documentID
                                                          .toString()),
                                                    );
                                                  }).toList()

                                                //  snapshot.data != null
                                                //     ? snapshot.data.documents
                                                //         .map((DocumentSnapshot document) {
                                                //         // final List<DocumentSnapshot> documents =
                                                //         //     document.data["local"];

                                                //           return DropdownMenuItem(
                                                //               value: document["locals"].toString(),
                                                //               child: new Container(
                                                //                 height: 100.0,
                                                //                 child: new Text(
                                                //                   document.data["locals"][i].toString(),
                                                //                 ),
                                                //               ));

                                                //       }).toList()

                                                : DropdownMenuItem(
                                                    value: 'null',
                                                    child: new Container(
                                                      height: 100.0,
                                                      child: new Text('null'),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance
                                        .collection("Sellers")
                                        .document(user.uid)
                                        .collection("Brand")
                                        .snapshots(),
                                    builder: (context, dropbt) {
                                      if (!dropbt.hasData ||
                                          dropbt.data.documents.length == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "No Brand Added",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FormField<String>(
                                          builder:
                                              (FormFieldState<String> state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 16.0),
                                                  hintText: 'Select Brand',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))),
                                              isEmpty:
                                                  _brandSelectedValue == '',
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  hint: Text(
                                                      "Select Brand (Optional)"),
                                                  value: _brandSelectedValue,
                                                  isDense: true,
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      _brandSelectedValue =
                                                          newValue;
                                                      state.didChange(newValue);
                                                    });
                                                  },
                                                  items: dropbt.data != null
                                                      ? dropbt.data.documents
                                                          .map((f) {
                                                          return DropdownMenuItem(
                                                            value: f.documentID
                                                                .toString(),
                                                            child: Text(f
                                                                .documentID
                                                                .toString()),
                                                          );
                                                        }).toList()

                                                      //  snapshot.data != null
                                                      //     ? snapshot.data.documents
                                                      //         .map((DocumentSnapshot document) {
                                                      //         // final List<DocumentSnapshot> documents =
                                                      //         //     document.data["local"];

                                                      //           return DropdownMenuItem(
                                                      //               value: document["locals"].toString(),
                                                      //               child: new Container(
                                                      //                 height: 100.0,
                                                      //                 child: new Text(
                                                      //                   document.data["locals"][i].toString(),
                                                      //                 ),
                                                      //               ));

                                                      //       }).toList()

                                                      : DropdownMenuItem(
                                                          value: 'null',
                                                          child: new Container(
                                                            height: 100.0,
                                                            child: new Text(
                                                                'null'),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),

                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                            child: TextFormField(
                              controller: productNameController,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: active),
                                  ),
                                  hintText: 'Product Name *',
                                  focusColor: active),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'You Must Enter The Product Name';
                                } else if (value.length < 3) {
                                  return 'Add Full Product Name';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                            child: TextFormField(
                              maxLines: 5,
                              controller: productDesController,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: active),
                                  ),
                                  hintText: 'Product Description *',
                                  focusColor: active),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'You Must Enter The Product Details';
                                } else if (value.length < 3) {
                                  return 'Add More Product Details';
                                }
                              },
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
                              width: 350,
                              child: FlatButton.icon(
                                icon: Icon(Icons.add),
                                onPressed: _textdes,
                                label: Text(_promotext),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _textfielddes,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 0, 12, 12),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: productPromoController,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: active),
                                              ),
                                              hintText: 'Create Your Promocode',
                                              focusColor: active),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 0, 12, 12),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              productPromoDicountController,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: active),
                                              ),
                                              hintText: 'Discount Price',
                                              focusColor: active),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 350,
                                  height: 30,
                                  child: FlatButton.icon(
                                      textColor: Colors.white,
                                      color: active,
                                      onPressed: () {
                                        setState(() {
                                          if (productPromoController
                                                  .text.isNotEmpty &&
                                              productPromoDicountController
                                                  .text.isNotEmpty) {
                                            if (promocode.length == 0 &&
                                                promoprice.length == 0) {
                                              promocode.add(
                                                  productPromoController.text);
                                              promoprice.add(
                                                  productPromoDicountController
                                                      .text);
                                              productPromoController.clear();
                                              productPromoDicountController
                                                  .clear();
                                              print(promocode);
                                            } else if (promocode.length > 0) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "You Can Add Only One Promocode");
                                            }
                                          } else if (productPromoController
                                              .text.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please Create promocode");
                                          } else if (productPromoDicountController
                                              .text.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please Add Discount Price promocode");
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text("Add")),
                                ),
                                Divider(),
                                buildCard(),
                                Divider()
                              ],
                            ),
                          ),
                          // ListView.builder(
                          //     itemCount: promocode.length,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return Card(
                          //         child: ListTile(
                          //           title: Text(promocode[index]),
                          //         ),
                          //       );
                          //     }),
//              select category
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: <Widget>[
                          //     // Expanded(
                          //     //   flex: 2,
                          //     //   child: Padding(
                          //     //     padding:
                          //     //         const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                          //     //     child: Text(
                          //     //       'Category:',
                          //     //       style: TextStyle(color: active),
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //     // Expanded(
                          //     //   flex: 3,
                          //     //   child: StreamBuilder<QuerySnapshot>(
                          //     //       stream: Firestore.instance
                          //     //           .collection("Sellers")
                          //     //           .document(user.uid)
                          //     //           .collection("Category")
                          //     //           .snapshots(),
                          //     //       builder: (context, snapshot) {
                          //     //         if (!snapshot.hasData ||
                          //     //             snapshot.data.documents.length == 0) {
                          //     //           return Text(
                          //     //             "No Catergory Added",
                          //     //           );
                          //     //         }
                          //     //         return DropdownButton<String>(
                          //     //           value: category,
                          //     //           isExpanded: true,
                          //     //           hint: Text("Category *"),
                          //     //           isDense: true,
                          //     //           onChanged: (String newValue) {
                          //     //             setState(() {
                          //     //               final snackBar = SnackBar(
                          //     //                 backgroundColor: Colors.white,
                          //     //                 content: Text(
                          //     //                   'Your Category Is $newValue',
                          //     //                   style: TextStyle(color: active),
                          //     //                 ),
                          //     //               );
                          //     //               Scaffold.of(context)
                          //     //                   .showSnackBar(snackBar);
                          //     //               category = newValue;
                          //     //               // _onShopDropItemSelected(newValue);
                          //     //             });
                          //     //           },
                          //     //           items: snapshot.data != null
                          //     //               ? snapshot.data.documents.map((f) {
                          //     //                   return DropdownMenuItem(
                          //     //                     value:
                          //     //                         f.documentID.toString(),
                          //     //                     child: Text(
                          //     //                         f.documentID.toString()),
                          //     //                   );
                          //     //                 }).toList()

                          //     //               //  snapshot.data != null
                          //     //               //     ? snapshot.data.documents
                          //     //               //         .map((DocumentSnapshot document) {
                          //     //               //         // final List<DocumentSnapshot> documents =
                          //     //               //         //     document.data["local"];

                          //     //               //           return DropdownMenuItem(
                          //     //               //               value: document["locals"].toString(),
                          //     //               //               child: new Container(
                          //     //               //                 height: 100.0,
                          //     //               //                 child: new Text(
                          //     //               //                   document.data["locals"][i].toString(),
                          //     //               //                 ),
                          //     //               //               ));

                          //     //               //       }).toList()

                          //     //               : DropdownMenuItem(
                          //     //                   value: 'null',
                          //     //                   child: new Container(
                          //     //                     height: 100.0,
                          //     //                     child: new Text('null'),
                          //     //                   ),
                          //     //                 ),
                          //     //         );
                          //     //       }),
                          //     // ),
                          //     Expanded(
                          //       flex: 2,
                          //       child: Padding(
                          //         padding:
                          //             const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                          //         child: Text(
                          //           'Brand:',
                          //           style: TextStyle(color: active),
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       flex: 3,
                          //       child: StreamBuilder<QuerySnapshot>(
                          //           stream: Firestore.instance
                          //               .collection("Sellers")
                          //               .document(user.uid)
                          //               .collection("Brand")
                          //               .snapshots(),
                          //           builder: (context, snapshot) {
                          //             if (!snapshot.hasData ||
                          //                 snapshot.data.documents.length == 0) {
                          //               return Text("No Brand Added");
                          //             }

                          //             return DropdownButton<String>(
                          //               value: brand,
                          //               isExpanded: true,
                          //               hint: Text("Brand"),
                          //               isDense: true,
                          //               onChanged: (String newValue) {
                          //                 setState(() {
                          //                   final snackBar = SnackBar(
                          //                     backgroundColor: Colors.white,
                          //                     content: Text(
                          //                       'Your Brand Is $newValue',
                          //                       style: TextStyle(color: active),
                          //                     ),
                          //                   );
                          //                   Scaffold.of(context)
                          //                       .showSnackBar(snackBar);
                          //                   brand = newValue;
                          //                   // _onShopDropItemSelected(newValue);
                          //                 });
                          //               },
                          //               items: snapshot.data != null
                          //                   ? snapshot.data.documents.map((f) {
                          //                       return DropdownMenuItem(
                          //                         value:
                          //                             f.documentID.toString(),
                          //                         child: Text(
                          //                             f.documentID.toString()),
                          //                       );
                          //                     }).toList()

                          //                   //  snapshot.data != null
                          //                   //     ? snapshot.data.documents
                          //                   //         .map((DocumentSnapshot document) {
                          //                   //         // final List<DocumentSnapshot> documents =
                          //                   //         //     document.data["local"];

                          //                   //           return DropdownMenuItem(
                          //                   //               value: document["locals"].toString(),
                          //                   //               child: new Container(
                          //                   //                 height: 100.0,
                          //                   //                 child: new Text(
                          //                   //                   document.data["locals"][i].toString(),
                          //                   //                 ),
                          //                   //               ));

                          //                   //       }).toList()

                          //                   : DropdownMenuItem(
                          //                       value: 'null',
                          //                       child: new Container(
                          //                         height: 100.0,
                          //                         child: new Text('null'),
                          //                       ),
                          //                     ),
                          //             );
                          //           }),
                          //     ),
                          //     // StreamBuilder<QuerySnapshot>(
                          //     //     stream: Firestore.instance
                          //     //         .collection("Sellers")
                          //     //         .document(user.uid)
                          //     //         .collection("Brand")
                          //     //         .snapshots(),
                          //     //     builder: (context, snapshot) {
                          //     //       // List<DropdownMenuItem> servicess = [];
                          //     //       // final List<DocumentSnapshot> documentss =
                          //     //       //     snapshot?.data?.documents;
                          //     //       if (!snapshot.hasData ||
                          //     //           snapshot.data.documents.length == 0) {
                          //     //         return Center(
                          //     //             child: CircularProgressIndicator());
                          //     //       }
                          //     //       // return InputDecorator(
                          //     //       //   decoration: InputDecoration(
                          //     //       //     //labelText: 'Activity',
                          //     //       //     hintText: 'Choose an category',
                          //     //       //     hintStyle: TextStyle(
                          //     //       //       color: active,
                          //     //       //       fontSize: 16.0,
                          //     //       //       fontFamily: "OpenSans",
                          //     //       //       fontWeight: FontWeight.normal,
                          //     //       //     ),
                          //     //       //   ),
                          //     //       //   isEmpty: category == null,
                          //     //       //   child:

                          //     //       return DropdownButton<String>(
                          //     //         value: category,
                          //     //         isExpanded: true,
                          //     //         hint: Text("Service"),
                          //     //         isDense: true,
                          //     //         onChanged: (String newValue) {
                          //     //           setState(() {
                          //     //             final snackBar = SnackBar(
                          //     //               backgroundColor: Colors.white,
                          //     //               content: Text(
                          //     //                 'Your Service Is $newValue',
                          //     //                 style: TextStyle(color: active),
                          //     //               ),
                          //     //             );
                          //     //             Scaffold.of(context)
                          //     //                 .showSnackBar(snackBar);
                          //     //             category = newValue;
                          //     //             // _onShopDropItemSelected(newValue);
                          //     //           });
                          //     //         },
                          //     //         items: snapshot.data != null
                          //     //             ? snapshot.data.documents.map((f) {
                          //     //                 return DropdownMenuItem(
                          //     //                   value: f.documentID.toString(),
                          //     //                   child: Text(
                          //     //                       f.documentID.toString()),
                          //     //                 );
                          //     //               }).toList()

                          //     //             //  snapshot.data != null
                          //     //             //     ? snapshot.data.documents
                          //     //             //         .map((DocumentSnapshot document) {
                          //     //             //         // final List<DocumentSnapshot> documents =
                          //     //             //         //     document.data["local"];

                          //     //             //           return DropdownMenuItem(
                          //     //             //               value: document["locals"].toString(),
                          //     //             //               child: new Container(
                          //     //             //                 height: 100.0,
                          //     //             //                 child: new Text(
                          //     //             //                   document.data["locals"][i].toString(),
                          //     //             //                 ),
                          //     //             //               ));

                          //     //             //       }).toList()

                          //     //             : DropdownMenuItem(
                          //     //                 value: 'null',
                          //     //                 child: new Container(
                          //     //                   height: 100.0,
                          //     //                   child: new Text('null'),
                          //     //                 ),
                          //     //               ),
                          //     //       );
                          //     //       // );
                          //     //     }),
                          //   ],
                          // ),

                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              (units == null)
                                  ? "Please Select Unit"
                                  : 'Your Product Per Rate Will Be Count This $units/Unit',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 12),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    controller: originalPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: active),
                                      ),

                                      hintText: 'Orginal Price *',
                                      // suffixIcon: InkWell(
                                      //   onTap: () {
                                      //     Fluttertoast.showToast(
                                      //         msg: "Long Press To Question Mark");
                                      //   },
                                      //   child: Tooltip(s
                                      //     child: Icon(Icons.help_outline,color: Colors.red,),
                                      //     message: "Add Products",
                                      //     waitDuration: Duration(milliseconds: 1),
                                      //   ),
                                      // ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'You Must Need Add Orginal Price';
                                      } else if (value.length > 5) {
                                        return "Must Add only 5 digit number";
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    controller: sellingPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: active),
                                      ),
                                      hintText: 'Selling Price *',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'You Must Need Add Price Of The Product';
                                      } else if (value.length > 5) {
                                        return "Add Number Less Then 5";
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection("units")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data.documents.length ==
                                                0) {
                                          return Text("No Brand Added");
                                        }

                                        return DropdownButton<String>(
                                          value: units,
                                          isExpanded: true,
                                          hint: Text("Eg: Kg"),
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              final snackBar = SnackBar(
                                                backgroundColor: Colors.white,
                                                content: Text(
                                                  'Your Unit Will Be $newValue',
                                                  style:
                                                      TextStyle(color: active),
                                                ),
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                              units = newValue;
                                              if (newValue == "Custom") {
                                                _unitcustom = true;
                                              } else {
                                                _unitcustom = false;
                                              }
                                              // _onShopDropItemSelected(newValue);
                                            });
                                          },
                                          items: snapshot.data != null
                                              ? snapshot.data.documents
                                                  .map((f) {
                                                  return DropdownMenuItem(
                                                    value:
                                                        f.documentID.toString(),
                                                    child: Text(f.documentID
                                                        .toString()),
                                                  );
                                                }).toList()

                                              //  snapshot.data != null
                                              //     ? snapshot.data.documents
                                              //         .map((DocumentSnapshot document) {
                                              //         // final List<DocumentSnapshot> documents =
                                              //         //     document.data["local"];

                                              //           return DropdownMenuItem(
                                              //               value: document["locals"].toString(),
                                              //               child: new Container(
                                              //                 height: 100.0,
                                              //                 child: new Text(
                                              //                   document.data["locals"][i].toString(),
                                              //                 ),
                                              //               ));

                                              //       }).toList()

                                              : DropdownMenuItem(
                                                  value: 'null',
                                                  child: new Container(
                                                    height: 100.0,
                                                    child: new Text('null'),
                                                  ),
                                                ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildExpanded(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: quatityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: active),
                                ),
                                hintText: 'Stock Quantity *',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'You Must Need Add Price Of The Product';
                                } else if (value.length > 6) {
                                  return "Add Number Less Then 6";
                                }
                              },
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
                              width: 350,
                              child: FlatButton.icon(
                                icon: Icon(Icons.add),
                                onPressed: _toggle,
                                label: Text(_sizetext),
                              ),
                            ),
                          ),
                          Divider(),
                          Visibility(
                            visible: _visible,
                            child: Column(
                              children: <Widget>[
                                Text('Available Sizes'),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('XS'),
                                          onChanged: (value) =>
                                              changeSelectedSize('XS')),
                                      Text('XS'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('S'),
                                          onChanged: (value) =>
                                              changeSelectedSize('S')),
                                      Text('S'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('M'),
                                          onChanged: (value) =>
                                              changeSelectedSize('M')),
                                      Text('M'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('L'),
                                          onChanged: (value) =>
                                              changeSelectedSize('L')),
                                      Text('L'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('XL'),
                                          onChanged: (value) =>
                                              changeSelectedSize('XL')),
                                      Text('XL'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('XXL'),
                                          onChanged: (value) =>
                                              changeSelectedSize('XXL')),
                                      Text('XXL'),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('28'),
                                          onChanged: (value) =>
                                              changeSelectedSize('28')),
                                      Text('28'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('30'),
                                          onChanged: (value) =>
                                              changeSelectedSize('30')),
                                      Text('30'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('32'),
                                          onChanged: (value) =>
                                              changeSelectedSize('32')),
                                      Text('32'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('34'),
                                          onChanged: (value) =>
                                              changeSelectedSize('34')),
                                      Text('34'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('36'),
                                          onChanged: (value) =>
                                              changeSelectedSize('36')),
                                      Text('36'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('38'),
                                          onChanged: (value) =>
                                              changeSelectedSize('38')),
                                      Text('38'),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('40'),
                                          onChanged: (value) =>
                                              changeSelectedSize('40')),
                                      Text('40'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('42'),
                                          onChanged: (value) =>
                                              changeSelectedSize('42')),
                                      Text('42'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('44'),
                                          onChanged: (value) =>
                                              changeSelectedSize('44')),
                                      Text('44'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('46'),
                                          onChanged: (value) =>
                                              changeSelectedSize('46')),
                                      Text('46'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('48'),
                                          onChanged: (value) =>
                                              changeSelectedSize('48')),
                                      Text('48'),
                                      Checkbox(
                                          activeColor: active,
                                          value: selectedSizes.contains('50'),
                                          onChanged: (value) =>
                                              changeSelectedSize('50')),
                                      Text('50'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          FlatButton(
                            color: active,
                            textColor: white,
                            child: Text('Add Product'),
                            onPressed: () {
                              validateAndUpload(
                                snapshot.data.userName.toString(),
                                snapshot.data.uid.toString(),
                                snapshot.data.catergory.toString(),
                              );
                            },
                          )
                        ],
                      ),
              ),
            );
          }),
    );
  }

  buildExpanded() {
    if (_unitcustom == true) {
      return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Visibility(
            visible: _unitcustom,
            child: TextFormField(
              controller: customUnitController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: active),
                ),
                hintText: 'Custom Units Detail Write In Short Eg: Ltr',
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  buildCard() {
    if (promocode.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No Promocode Added"),
      );
    } else {
      return Card(
          child: ListTile(
        title: Text(promocode[0]),
        subtitle: Text("₹\ ${promoprice[0]}"),
        trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                promocode.clear();
                promoprice.clear();
              });
            }),
      ));
    }
  }

  void _categoryAlert(BuildContext context, String id) {
    var alert = AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          inputFormatters: [
            BlacklistingTextInputFormatter(" "),
          ],
          controller: categoryController,
          validator: (value) {
            assert(value != null);
            if (value.isEmpty) {
              return 'category cannot be empty';
            } else {
              return "Samething Went Wrong";
            }
          },
          decoration: InputDecoration(hintText: "Add Category"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            textColor: active,
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                sl
                    .get<CategoryService>()
                    .createCategory(categoryController.text, id);
                // _categoryService.createCategory(categoryController.text, id);
                Fluttertoast.showToast(msg: 'category created');
                categoryController.clear();
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                Fluttertoast.showToast(msg: "Please Enter Category");
              }
            },
            child: Text('ADD')),
        FlatButton(
            textColor: active,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //Navigator.of(context).pop();
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(
        useRootNavigator: true,
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => alert);
  }

  void _brandAlert(BuildContext context, String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          inputFormatters: [
            BlacklistingTextInputFormatter(" "),
          ],
          controller: brandController,
          validator: (value) {
            if (value.isEmpty) {
              return 'category cannot be empty';
            } else {
              return "Samething Went Wrong";
            }
          },
          decoration: InputDecoration(
            hintText: "Add Brand",
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            textColor: active,
            onPressed: () {
              if (brandController.text.isNotEmpty) {
                sl.get<BrandService>().createBrand(brandController.text, id);
                // _brandService.createBrand(brandController.text, id);
                Fluttertoast.showToast(msg: 'brand added');
                Navigator.of(context, rootNavigator: true).pop();
                brandController.clear();
              } else {
                Fluttertoast.showToast(msg: "Please Enter Brand");
              }
            },
            child: Text('ADD')),
        FlatButton(
            textColor: active,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _toggle() {
    setState(() {
      _sizetext = (_visible == false) ? "Hide Size" : "Add Size (Optional)";
      _visible = !_visible;
    });
  }

  void _textdes() {
    setState(() {
      _promotext =
          (_textfielddes == false) ? "Hide Promo" : "Add Promocode (Optional)";
      _textfielddes = !_textfielddes;
    });
  }
}
