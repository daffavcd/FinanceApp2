import 'package:flutter/material.dart';
import 'package:uts/model/category.dart';
import 'package:uts/model/dbhelper.dart';

class EntryFormCategory extends StatefulWidget {
  final Category category;
  EntryFormCategory(this.category);
  @override
  EntryFormCategoryState createState() => EntryFormCategoryState(this.category);
}

//class controller
class EntryFormCategoryState extends State<EntryFormCategory> {
  DbHelper dbHelper = DbHelper();
  Category category;
  EntryFormCategoryState(this.category);
  TextEditingController categoryNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //kondisi
    bool check = false;
    if (category != null) {
      categoryNameController.text = category.categoryName;
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
                          if (category == null) {
                            category = Category(
                              categoryNameController.text,
                            );
                          } else {
                            category.categoryName = categoryNameController.text;
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
                            dbHelper.deleteCategory(category.categoryId);
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
}
