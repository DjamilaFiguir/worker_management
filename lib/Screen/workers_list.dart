import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion/Models/worker.dart';
import 'package:gestion/Screen/worker_detail.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class WorkerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WorkerListState();
  }
}

class WorkerListState extends State<WorkerList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Worker> workerList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (workerList == null) {
      workerList = List<Worker>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Workers'),
      ),
      body: getWorkerListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Worker('', ''), 'Add Worker');
        },
        tooltip: 'Add Worker',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getWorkerListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.workerList[position].nameEdit),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.workerList[position].nameEdit,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.workerList[position].phoneEdit),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, workerList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.workerList[position], 'Edit Worker');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Worker worker) async {
    int result = await databaseHelper.deleteWorker(worker.id);
    if (result != 0) {
      _showSnackBar(context, 'Worker Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Worker worker, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WorkerDetail(worker, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Worker>> workerListFuture = databaseHelper.getWorkerList();
      workerListFuture.then((workerList) {
        setState(() {
          this.workerList = workerList;
          this.count = workerList.length;
        });
      });
    });
  }

  
}