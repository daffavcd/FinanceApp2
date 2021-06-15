import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts/model/category.dart';
import 'package:uts/model/dbhelper.dart';
import 'package:uts/model/mymoney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';

class EntryFormMoney extends StatefulWidget {
  final String id;
  final String type;
  final String categoryId;
  final String desc;
  final String amount;
  EntryFormMoney(this.id, this.type, this.categoryId, this.desc, this.amount);
  @override
  EntryFormMoneyState createState() => EntryFormMoneyState(
      this.id, this.type, this.categoryId, this.desc, this.amount);
}

//class controller
class EntryFormMoneyState extends State<EntryFormMoney> {
  String userUid = uid;
  String dropdownAtas;
  String dropdownValue = 'Income';
  DbHelper dbHelper = DbHelper();

  String tempid;
  String temptype;
  String tempcategoryId;
  String tempdesc;
  String tempamount;

  EntryFormMoneyState(
      String id, String type, String categoryId, String desc, String amount) {
    this.tempid = id;
    this.temptype = type;
    this.tempcategoryId = categoryId;
    this.tempdesc = desc;
    this.tempamount = amount;
  }

  int count = 0;
  List<Category> itemList;
  CollectionReference categoryku =
      FirebaseFirestore.instance.collection('Category');

  void get_option() async {
    // final Future<Database> dbFuture = dbHelper.initDb();
    // dbFuture.then((database) {
    //   Future<List<Category>> itemListFuture = dbHelper.getCategoryList();
    //   itemListFuture.then((itemList) {
    //     setState(() {
    //       this.itemList = itemList;
    //       this.dropdownAtas = itemList[0].categoryId.toString();
    //       this.count = itemList.length;
    //     });
    //   });
    // });
    categoryku
        // .orderBy('CategoryName', descending: true)
        .where('UserId', isEqualTo: userUid)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          this.dropdownAtas = doc.id;
        });
      });
    });
  }

  Mymoney mymoney;
  TextEditingController descController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool check = false;
  void initState() {
    super.initState();
    if (tempcategoryId != null) {
      dropdownValue = temptype;
      dropdownAtas = tempcategoryId;
      descController.text = tempdesc;
      amountController.text = tempamount;
      check = true;
    } else {
      get_option();
    }
  }

  @override
  Widget build(BuildContext context) {
    //kondisi

    //rubah
    return Scaffold(
        appBar: AppBar(
          title: tempcategoryId == null
              ? Text('Add New Transaction')
              : Text('Edit Transaction'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  items: <String>['Income', 'Outcome'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (selectedItem) => setState(() {
                    this.dropdownValue = selectedItem;
                  }),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: categoryku
                    // .orderBy('CategoryName', descending: true)
                    .where('UserId', isEqualTo: userUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Text('PLease Wait')
                      : DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          items:
                              snapshot.data.docs.map((DocumentSnapshot docs) {
                            return new DropdownMenuItem<String>(
                              value: docs.id,
                              child: new Text(
                                docs["CategoryName"],
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }).toList(),
                          value: dropdownAtas,
                          onChanged: (selectedItem) => setState(() {
                            this.dropdownAtas = selectedItem;
                          }),
                        );
                },
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              //   child: DropdownButton<String>(
              //     isExpanded: true,
              //     value: dropdownAtas,
              //     items: itemList.map((value) {
              //       return new DropdownMenuItem<String>(
              //         value: value.categoryId.toString(),
              //         child: new Text(
              //           value.categoryName,
              //           style: TextStyle(fontSize: 18),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (selectedItem) => setState(() {
              //       dropdownAtas = selectedItem;
              //     }),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: descController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              // harga
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),
              // tombol button
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
                          if (tempid == null) {
                            addItem();
                            // category = Category(
                            //   categoryNameController.text,
                            // );
                          } else {
                            updateItem();
                            // category.categoryName = categoryNameController.text;
                          }
                          Navigator.pop(context, mymoney);
                          // kembali ke layar sebelumnya dengan membawa objek mymoney
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
                            Navigator.pop(context, mymoney);
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
        FirebaseFirestore.instance.collection('MyMoney');

    colectionsCategory
        .add({
          'Amount': amountController.text, // John Doe
          'CategoryId': dropdownAtas, // John Doe
          'Desc': descController.text, // John Doe
          'Type': dropdownValue, // John Doe/ John Doe
          'UserId': userUid
        })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }

  Future<void> updateItem() async {
    CollectionReference colectionsCategory =
        FirebaseFirestore.instance.collection('MyMoney');

    colectionsCategory
        .doc(tempid)
        .update({
          'Amount': amountController.text,
          'CategoryId': dropdownAtas,
          'Desc': descController.text,
          'Type': dropdownValue
        })
        .then((value) => print("Item Updated"))
        .catchError((error) => print("Failed to update Item: $error"));
  }

  Future<void> deleteItem() {
    CollectionReference colectionsCategory =
        FirebaseFirestore.instance.collection('MyMoney');

    return colectionsCategory
        .doc(tempid)
        .delete()
        .then((value) => print("Item Deleted"))
        .catchError((error) => print("Failed to delete Item: $error"));
  }
}
