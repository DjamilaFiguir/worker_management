import 'package:flutter/material.dart';
import 'package:gestion/Models/design.dart';
import 'package:gestion/Models/worker.dart';
import 'package:gestion/Screen/search.dart';
import '../database_helper.dart';

class WorkerDetail extends StatefulWidget {
  final String appBarTitle;
  final Worker worker;

  WorkerDetail(this.worker, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return WorkerDetailState(this.worker, this.appBarTitle);
  }
}

class WorkerDetailState extends State<WorkerDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Worker worker;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  WorkerDetailState(this.worker, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    nameController.text = worker.nameEdit;
    phoneController.text = worker.phoneEdit;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
            backgroundColor: appbarColor,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 15,right: 15),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Name Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 15,right: 15),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Phone Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 15,right: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color:appbarColor ,
                          elevation: 6,
                          textColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.save,color: Colors.white,size: 22,),
                              SizedBox(width: 10,),
                              Text(
                              'Save',
                              textScaleFactor: 1.45,
                            ),
                            ],                        
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 25.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color:  Color.fromARGB(220,232, 232, 232),
                          textColor: appbarColor,
                          elevation: 6,
                         child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.delete,color: appbarColor,size: 22,),
                              SizedBox(width: 10,),
                              Text(
                              'Delete',
                              textScaleFactor: 1.45,
                            ),
                            ],                        
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Worker
  void updateTitle() {
    worker.nameEdit = nameController.text;
  }

  // Update the description of worker
  void updateDescription() {
    worker.phoneEdit = phoneController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    //worker.amountEdit = 0;
    int result;
    if (worker.id != null) {
      // Case 1: Update operation
      result = await helper.updateWorker(worker);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertWorker(worker);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Worker Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Worker');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (worker.id == null) {
      _showAlertDialog('Status', 'No Worker was deleted');
      return;
    }

    int result = await helper.deleteWorker(worker.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Worker Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Worker');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
