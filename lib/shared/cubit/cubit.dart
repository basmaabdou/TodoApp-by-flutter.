 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_app/new_tasks/new_tasks_screen.dart';



class AppCubit extends Cubit<AppStates> {
  AppCubit(initialState) : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBar());
  }

  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];


  void createDataBase()  {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version){
          print('DB created');
          database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT ,status TEXT) ')
              .then((value) {
            print('Table Created');
          }).catchError((error){
            print ('error when creat table ${error.toString()}');
          });
        },
        onOpen: (database){
          print('DB open');
          getDataFromDB(database);
        }
    ).then((value) {
      database=value;
      emit(AppCreateDatabase());
     });
  }

 insertToDatabase({
    required String title,
    required String time,
    required String date
  })async  {
     await database.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks (title,time,date,status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabase());
        getDataFromDB(database);
      }).catchError((error){
        print('error when insert values ${error.toString()}');
      });
      return  Future(() => null);
    });
  }

  // Future<List<Map>> getDataFromDB(database)async{
  //   // to make it zero (when clicked not add all)
  //   newTasks=[];
  //   doneTasks=[];
  //   archiveTasks=[];
  //
  //   emit(AppGetLoadingDatabase());
  //   return await database.rawQuery('SELECT * FROM tasks').then((value) {
  //     value.forEach((element) {
  //       if(element['status'] == 'new'){
  //         newTasks.add(element);
  //       }else if(element['status']=='done'){
  //         doneTasks.add(element);
  //       }else{
  //         archiveTasks.add(element);
  //       }
  //     });
  //     emit(AppGetDatabase());
  //   });
  // }

  Future<List<Map>> getDataFromDB(database) async {
    // to make it zero (when clicked not add all)
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetLoadingDatabase());
    List<Map> result = await database.rawQuery('SELECT * FROM tasks');
    // if (result == null) {
    //   return Future.value([]);
    // }
    result.forEach((element) {
      if (element['status'] == 'new') {
        newTasks.add(element);
      } else if (element['status'] == 'done') {
        doneTasks.add(element);
      } else {
        archiveTasks.add(element);
      }
    });
    emit(AppGetDatabase());
    return result;
  }

 void updateData({
    required String status,
    required int id
}){
      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
      ).then((value) {
        getDataFromDB(database);
         emit(AppUpdateDatabase());
      });
  }

  void deleteData({required int id}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(database);
      emit(AppDeleteDatabase());
    });
  }

  bool isBottomSheet =false;
  IconData fabIcon=Icons.edit;
  void changeBottomSheet({
    required isSheet,
    required icon
  })
  {
   isBottomSheet=isSheet;
   fabIcon=icon;
   emit(AppChangeBottomSheet());
  }



}

