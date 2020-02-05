import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  ProductService productService = ProductService();
  final TextEditingController quatityController = TextEditingController();
  final TextEditingController originalPriceController = TextEditingController();
  Color active = Colors.deepPurple[400];
  List<String> selectedSizes = <String>[];
  Color white = Colors.white;

  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();
  String _currentBrand;
  String _currentCategory;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image1;
  File _image2;
  File _image3;

  int get sellingPrice => int.parse(sellingPriceController.text);
  int get orginalPrice => int.parse(originalPriceController.text);

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data['category']),
                value: categories[i].data['category']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandosDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(brands[i].data['brand']),
                value: brands[i].data['brand']));
      });
    }
    return items;
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandosDropDown();
      _currentBrand = brands[0].data['brand'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

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

  void validateAndUpload(String username, String uid) async {
    var id = Uuid().v1();
    try {
      if (_currentBrand != null && _currentCategory != null) {
        if (_formKey.currentState.validate()) {
          setState(() => isLoading = true);
          if (_image1 != null && _image2 != null && _image3 != null) {
            if (selectedSizes.isNotEmpty) {
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
                for (var i = 0; i < spiltList.length; i++) {
                  for (var y = 1; y < spiltList[i].length + 1; y++) {
                    indexList.add(spiltList[i].substring(0, y).toLowerCase());
                  }
                }
                productService.uploadProduct({
                  "indexList": indexList,
                  "ProductReview": false,
                  "ProductName": productNameController.text,
                  "UploaderName": username,
                  "price": double.parse(sellingPriceController.text),
                  "Orignal Price": int.parse(originalPriceController.text),
                  "sizes": selectedSizes,
                  "images": imageList,
                  "quantity": int.parse(quatityController.text),
                  "brand": _currentBrand,
                  "Discount":
                      (orginalPrice - sellingPrice) / orginalPrice * 100,
                  "category": _currentCategory,
                  "Reference": productIds,
                  "TimeStamp": Timestamp.now()
                }, username);
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
            Fluttertoast.showToast(msg: 'all the images must be provided');
          }
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(
            msg:
                "Add Category And Brand Go Manage Section Scroll Down And Both Thing");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getBrands();
  }

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
                              'Select The Clear And Proper Images',
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
                                                source: ImageSource.gallery),
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

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: productNameController,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: active),
                                  ),
                                  hintText: 'Product Name',
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

//              select category
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Category: ',
                                  style: TextStyle(color: active),
                                ),
                              ),
                              DropdownButton(
                                items: categoriesDropDown,
                                onChanged: changeSelectedCategory,
                                value: _currentCategory,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Brand: ',
                                  style: TextStyle(color: active),
                                ),
                              ),
                              DropdownButton(
                                items: brandsDropDown,
                                onChanged: changeSelectedBrand,
                                value: _currentBrand,
                              ),
                            ],
                          ),

//

                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    controller: originalPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: active),
                                      ),

                                      hintText: 'Orginal Price',
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
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    controller: sellingPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: active),
                                      ),
                                      hintText: 'Selling Price',
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
                                hintText: 'Stock Quantity',
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

                          FlatButton(
                            color: active,
                            textColor: white,
                            child: Text('Add Product'),
                            onPressed: () {
                              if (snapshot.data.bankDetailBool == false) {
                                Fluttertoast.showToast(
                                    msg: "Please Add Your Bank Detail");
                              } else
                                validateAndUpload(
                                    snapshot.data.userName.toString(),
                                    snapshot.data.uid.toString());
                            },
                          )
                        ],
                      ),
              ),
            );
          }),
    );
  }
}
