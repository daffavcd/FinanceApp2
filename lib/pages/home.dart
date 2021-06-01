import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:uts/model/dbhelper.dart';
import 'package:uts/model/mymoney.dart';
import 'package:uts/pages/categoryHome.dart';
import 'package:uts/pages/sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'entryFormMoney.dart';
import 'loginPage.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  DbHelper dbHelper = DbHelper();
  int count = 0;
  int total_money;
  List<Mymoney> itemList;
  CollectionReference mymoneyku =
      FirebaseFirestore.instance.collection('MyMoney');

  @override
  void initState() {
    super.initState();
    cariTotalFirst();
  }

  void cariTotalFirst() async {
    // final Future<Database> dbFuture = dbHelper.initDb();
    // dbFuture.then((database) {
    //   Future<List<Mymoney>> itemListFuture = dbHelper.getItemList();
    //   itemListFuture.then((itemList) {
    //     setState(() {
    //       for (var i = 0; i < itemList.length; i++) {
    //         if (itemList[i].type.toString() == 'Income') {
    //           total_money = total_money + itemList[i].amount;
    //         } else if (itemList[i].type.toString() == 'Outcome') {
    //           total_money = total_money - itemList[i].amount;
    //         }
    //       }
    //     });
    //   });
    // });
    total_money = 0;
    mymoneyku.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          if (doc['Type'] == 'Income') {
            total_money = total_money + int.parse(doc['Amount']);
          } else if (doc['Type'] == 'Outcome') {
            total_money = total_money - int.parse(doc['Amount']);
          }
        });
      });
    });
  }

  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Mymoney>();
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
                print("Container clicked");
              },
              child: Container(
                alignment: Alignment.center,
                child: Text("My Money",
                    style: TextStyle(fontSize: 17, color: Colors.black87)),
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border(
                      bottom: BorderSide(color: Colors.black87, width: 4),
                    )),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                navigateToCategoryHome(context, null);
              },
              child: Container(
                color: Colors.white70,
                alignment: Alignment.center,
                child: Text("Manage Category",
                    style: TextStyle(fontSize: 17, color: Colors.black87)),
                height: 50.0,
              ),
            ),
          ),
        ]),
        Expanded(
          child: StreamBuilder(
            stream: mymoneyku
                // .orderBy('id', descending: true)
                // .where('UserId', isEqualTo: userUid)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Text('PLease Wait')
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.docs[index];
                        if (data['Type'] == 'Income') {
                          return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.arrow_back),
                              ),
                              title: Text(
                                "Rp." + data['Amount'].toString() + ",00",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              subtitle: Text(data['Desc'].toString()),
                              onTap: () async {
                                // var item =
                                //     await navigateToEntryForm(context, this.itemList[index]);

                                // if (item != null) {
                                //   int result = await dbHelper.updateMoney(item);

                                //   updateListView();
                                // }
                              },
                            ),
                          );
                        } else {
                          return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.arrow_forward),
                              ),
                              title: Text(
                                "Rp." + data['Amount'].toString() + ",00",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              subtitle: Text(data['Desc'].toString()),
                              onTap: () async {
                                // var item =
                                //     await navigateToEntryForm(context, this.itemList[index]);

                                // if (item != null) {
                                //   int result = await dbHelper.updateMoney(item);

                                //   updateListView();
                                // }
                              },
                            ),
                          );
                        }
                      },
                    );
            },
          ),
        ),
        Container(
          height: 70,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.deepOrange[300],
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Text("Balance : Rp. $total_money,00",
                style: TextStyle(fontSize: 22, color: Colors.black87)),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var item = await navigateToEntryForm(context, null);
          if (item != null) {
            // int result = await dbHelper.insertMoney(item);
            // if (item.type == 'Income') {
            //   setState(() {
            //     this.total_money += item.amount;
            //   });
            // } else {
            //   setState(() {
            //     this.total_money -= item.amount;
            //   });
            // }
            // if (result > 0) {
            // }
          }
          cariTotalFirst();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Mymoney> navigateToEntryForm(
      BuildContext context, Mymoney item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryFormMoney(item);
    }));
    return result;
  }

  Future<Mymoney> navigateToCategoryHome(
      BuildContext context, Mymoney item) async {
    var result = Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return CategoryHome();
    }));
    return result;
  }

  // ListView createListView() {
  //   TextStyle textStyle = Theme.of(context).textTheme.headline5;
  //   return ListView.builder(
  //     itemCount: count,
  //     itemBuilder: (BuildContext context, int index) {
  //       if (itemList[index].type == 'Income') {
  //         return Card(
  //           color: Colors.white,
  //           elevation: 2.0,
  //           child: ListTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.red,
  //               child: Icon(Icons.arrow_back),
  //             ),
  //             title: Text(
  //               "Rp." + this.itemList[index].amount.toString() + ",00",
  //               style: textStyle,
  //             ),
  //             subtitle: Text(this.itemList[index].desc.toString()),
  //             onTap: () async {
  //               // var item =
  //               //     await navigateToEntryForm(context, this.itemList[index]);

  //               // if (item != null) {
  //               //   int result = await dbHelper.updateMoney(item);

  //               //   updateListView();
  //               // }
  //             },
  //           ),
  //         );
  //       } else {
  //         return Card(
  //           color: Colors.white,
  //           elevation: 2.0,
  //           child: ListTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.red,
  //               child: Icon(Icons.arrow_forward),
  //             ),
  //             title: Text(
  //               "Rp." + this.itemList[index].amount.toString() + ",00",
  //               style: textStyle,
  //             ),
  //             subtitle: Text(this.itemList[index].desc.toString()),
  //             onTap: () async {
  //               // var item =
  //               //     await navigateToEntryForm(context, this.itemList[index]);

  //               // if (item != null) {
  //               //   int result = await dbHelper.updateMoney(item);

  //               //   updateListView();
  //               // }
  //             },
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  //update List item
  // void updateListView() {
  //   final Future<Database> dbFuture = dbHelper.initDb();
  //   dbFuture.then((database) {
  //     Future<List<Mymoney>> itemListFuture = dbHelper.getItemList();
  //     itemListFuture.then((itemList) {
  //       setState(() {
  //         this.itemList = itemList;
  //         this.count = itemList.length;
  //       });
  //     });
  //   });
  // }
}
