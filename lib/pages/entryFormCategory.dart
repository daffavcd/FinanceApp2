import 'package:flutter/material.dart';
import 'package:uts/model/category.dart';
import 'package:uts/model/dbhelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uts/pages/sign_in.dart';

class EntryFormCategory extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  EntryFormCategory(this.categoryName, this.categoryId);
  @override
  EntryFormCategoryState createState() =>
      EntryFormCategoryState(this.categoryName, this.categoryId);
}

//class controller
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class EntryFormCategoryState extends State<EntryFormCategory> {
  String userUid = uid;
  DbHelper dbHelper = DbHelper();
  Category category;

  String tempcategoryName;
  String tempcategoryId;

  EntryFormCategoryState(String categoryName, String categoryId) {
    this.tempcategoryName = categoryName;
    this.tempcategoryId = categoryId;
  }

  TextEditingController categoryNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //kondisi
    bool check = false;
    if (tempcategoryId != null) {
      categoryNameController.text = tempcategoryName;
      check = true;
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: category == null ? Text('Add New') : Text('Edit'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: categoryNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (tempcategoryId == null) {
                            addItem();
                            // category = Category(
                            //   categoryNameController.text,
                            // );
                          } else {
                            updateItem();
                            // category.categoryName = categoryNameController.text;
                          }
                          // kembali ke layar sebelumnya dengan membawa objek mymoney
                          Navigator.pop(context, category);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    // tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (check == true)
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            deleteItem();
                            // dbHelper.deleteCategory(category.categoryId);
                            Navigator.pop(context, category);
                          },
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ));
  }

  Future<void> addItem() async {
    CollectionReference colectionsCategory =
        FirebaseFirestore.instance.collection('Category');

    colectionsCategory
        .add({
          'CategoryName': categoryNameController.text, // John Doe
          'UserId': userUid
        })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }

  Future<void> updateItem() async {
    CollectionReference colectionsCategory =
        FirebaseFirestore.instance.collection('Category');

    colectionsCategory
        .doc(tempcategoryId)
        .update({'CategoryName': categoryNameController.text})
        .then((value) => print("Item Updated"))
        .catchError((error) => print("Failed to update Item: $error"));
  }

  Future<void> deleteItem() {
    CollectionReference colectionsCategory =
        FirebaseFirestore.instance.collection('Category');

    return colectionsCategory
        .doc(tempcategoryId)
        .delete()
        .then((value) => print("Item Deleted"))
        .catchError((error) => print("Failed to delete Item: $error"));
  }
}
