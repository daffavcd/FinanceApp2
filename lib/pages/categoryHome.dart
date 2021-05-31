import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts/model/category.dart';
import 'dart:async';

import 'package:uts/model/dbhelper.dart';
import 'package:uts/pages/entryFormCategory.dart';
import 'home.dart';
import 'loginPage.dart';
import 'sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//pendukung program asinkron
class CategoryHome extends StatefulWidget {
  @override
  CategoryHomeState createState() => CategoryHomeState();
}

class CategoryHomeState extends State<CategoryHome> {
  @override
  DbHelper dbHelper = DbHelper();

  int count = 0;
  List<Category> itemList;
  @override
  void initState() {
    super.initState();
    // updateListView();
  }

  Widget build(BuildContext context) {
    String userUid = uid;
    CollectionReference categoryku =
        FirebaseFirestore.instance.collection('Category');
    if (itemList == null) {
      itemList = List<Category>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('D-Moneyku Indonesia',
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        backgroundColor: Colors.deepOrange[200],
      ),
      body: Column(children: [
        Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                leading: Container(
                    padding: new EdgeInsets.all(40.0),
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(imageUrl),
                        ))),
                title: Text(
                  email,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  'Sign Out',
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  signOutGoogle();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            )
          ],
        ),
        Row(children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                navigateToHome(context, null);
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.white70,
                child: Text("My Money",
                    style: TextStyle(fontSize: 17, color: Colors.black87)),
                height: 50.0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Container clicked");
              },
              child: Container(
                alignment: Alignment.center,
                child: Text("Manage Category",
                    style: TextStyle(fontSize: 17, color: Colors.black87)),
                height: 50.0,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.black87, width: 4),
                )),
              ),
            ),
          ),
        ]),
        Expanded(
          child: StreamBuilder(
            stream: categoryku
                .orderBy('CategoryName', descending: true)
                // .where('UserId', isEqualTo: userUid)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Text('PLease Wait')
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.docs[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.inventory),
                            ),
                            title: Text(
                              data['CategoryName'],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onTap: () async {
                              print("Document keys:" + data.id);
                              await navigateToEntryForm(
                                  data['CategoryName'], data.id);

                              // if (item != null) {
                              // int result =
                              //     await dbHelper.updateCategory(item);

                              // updateListView();
                              // }
                            },
                          ),
                        );
                      },
                    );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("New Category"),
              onPressed: () async {
                var item = await navigateToEntryForm(null, null);
                if (item != null) {
                  int result = await dbHelper.insertCategory(item);
                  if (result > 0) {
                    // updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Category> navigateToEntryForm(
      String nameCategory, String idCategory) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryFormCategory(nameCategory, idCategory);
    }));
    return result;
  }

  Future<Category> navigateToHome(BuildContext context, Category item) async {
    var result = Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return Home();
    }));
    return result;
  }

  // ListView createListView() {
  //   TextStyle textStyle = Theme.of(context).textTheme.headline5;
  //   return ListView.builder(
  //     itemCount: count,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Card(
  //         color: Colors.white,
  //         elevation: 2.0,
  //         child: ListTile(
  //           leading: CircleAvatar(
  //             backgroundColor: Colors.red,
  //             child: Icon(Icons.inventory),
  //           ),
  //           title: Text(
  //             this.itemList[index].categoryName,
  //             style: textStyle,
  //           ),
  //           onTap: () async {
  //             var item =
  //                 await navigateToEntryForm(context, this.itemList[index]);

  //             if (item != null) {
  //               int result = await dbHelper.updateCategory(item);

  //               // updateListView();
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // //update List item
  // void updateListView() {
  //   final Future<Database> dbFuture = dbHelper.initDb();
  //   dbFuture.then((database) {
  //     Future<List<Category>> itemListFuture = dbHelper.getCategoryList();
  //     itemListFuture.then((itemList) {
  //       setState(() {
  //         this.itemList = itemList;
  //         this.count = itemList.length;
  //       });
  //     });
  //   });
  // }
}
