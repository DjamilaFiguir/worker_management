import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestion/Models/design.dart';
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
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Worker List');
  final TextEditingController _filter = new TextEditingController();
  List filteredNames = new List(); // names filtered by search text
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
         style: TextStyle(color: Colors.white,fontSize: 20),
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search,color: Colors.white70,),
            hintText: 'Search Worker...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Worker List');
        filteredNames = workerList;
        _filter.clear();
      }
    });
  }

  examplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = workerList;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    examplePageState();
    if (workerList == null) {
      workerList = List<Worker>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        backgroundColor: appbarColor,
        actions: <Widget>[
          new IconButton(
            icon: _searchIcon,
            onPressed: () => _searchPressed(),
          ),
        ],
      ),
      body: getWorkerListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Worker('', ''), 'Add Worker');
        },
        elevation: 7,
        backgroundColor: appbarColor,
        tooltip: 'Add Worker',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getWorkerListView() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .nameEdit
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: workerList == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white24,
          elevation: 0.0,
          child: ListTile(
            leading: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(75.0),
              ),
              color: Colors.white12,
              child: Icon(
                Icons.work,
                color: appbarColor,
              ),
            ),
            title: Text(filteredNames[position].nameEdit,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(filteredNames[position].phoneEdit),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('500 DZD'),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(filteredNames[position], 'Edit Worker');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  /*void _delete(BuildContext context, Worker worker) async {
    int result = await databaseHelper.deleteWorker(worker.id);
    if (result != 0) {
      _showSnackBar(context, 'Worker Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }*/

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
          filteredNames = workerList;
          this.count = workerList.length;
        });
      });
    });
  }
}
