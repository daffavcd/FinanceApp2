import 'package:flutter/material.dart';
import 'package:uts/model/dbhelper.dart';
import 'package:uts/model/mymoney.dart';

class EntryFormMoney extends StatefulWidget {
  final Mymoney mymoney;
  EntryFormMoney(this.mymoney);
  @override
  EntryFormMoneyState createState() => EntryFormMoneyState(this.mymoney);
}

//class controller
class EntryFormMoneyState extends State<EntryFormMoney> {
  String dropdownValue = 'Income';
  DbHelper dbHelper = DbHelper();
  Mymoney mymoney;
  EntryFormMoneyState(this.mymoney);
  TextEditingController descController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //kondisi
    bool check = false;
    if (mymoney != null) {
      descController.text = mymoney.desc;
      categoryIdController.text = mymoney.categoryId.toString();
      typeController.text = mymoney.type.toString();
      amountController.text = mymoney.amount.toString();
      check = true;
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: mymoney == null ? Text('Tambah') : Text('Ubah'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              // nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  items: <String>['Income', 'Outcome']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: descController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
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
                    labelText: 'Harga',
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
                          if (mymoney == null) {
                            // tambah data
                            // mymoney = Mymoney(
                            // nameController.text,
                            // int.parse(priceController.text),
                            // codeController.text,
                            // int.parse(qtyController.text));
                          } else {
                            // ubah data
                            // mymoney.code = codeController.text;
                            // mymoney.name = nameController.text;
                            // mymoney.price = int.parse(priceController.text);
                            // mymoney.qty = int.parse(qtyController.text);
                          }
                          // kembali ke layar sebelumnya dengan membawa objek mymoney
                          Navigator.pop(context, mymoney);
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
                            dbHelper.deleteMoney(mymoney.id);
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
}
