

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/component.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();



  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context) =>AppCubit(AppInitialState)..createDataBase() ,
      child: BlocConsumer <AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state) =>{
          if(state is AppInsertDatabase){
            Navigator.pop(context),
          }
        },
        builder:(context,state){
          AppCubit c=AppCubit.get(context);

          return Scaffold(
            key:   scaffoldKey,
            appBar: AppBar(
              title: Text(
                c.titles[c.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetLoadingDatabase ,
                builder: (context)=>c.screen[c.currentIndex],
                fallback: (context)=>Center(child: CircularProgressIndicator())
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()  {
                if(c.isBottomSheet){
                  if(formKey.currentState!.validate()) {
                    c.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                    // insertToDatabase(
                    //     title: titleController.text,
                    //     time: timeController.text,
                    //     date: dateController.text
                    // ).then((value) {
                    //   getDataFromDB(database).then((value) {
                    //     Navigator.pop(context);
                    //     isBottomSheet=false;
                    //     fabIcon=Icons.edit;
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) =>
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextForm(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  labelText: 'Task Title',
                                  prefix: Icons.title,
                                  validate: (value){
                                    if(value.isEmpty){
                                      return 'the email not allow to be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.0,),
                                defaultTextForm(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  labelText: "Task Time",
                                  prefix: Icons.watch_later_outlined,
                                  onTap: (){
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()).then((value) => {
                                      timeController.text=value!. format(context).toString()
                                    });
                                  },
                                  validate: (value){
                                    if(value.isEmpty){
                                      return 'the time not allow to be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.0,),
                                defaultTextForm(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  labelText: "Task Date",
                                  prefix: Icons.calendar_today,
                                  onTap: (){
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2024-05-03')).then((value) {
                                      dateController.text=DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (value){
                                    if(value.isEmpty){
                                      return 'the date not allow to be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 40,
                  ).closed.then((value) {
                    c.changeBottomSheet(isSheet: false, icon: Icons.edit);
                  });
                  c.changeBottomSheet(isSheet: true, icon: Icons.add);
                }
              },
              child: Icon(c.fabIcon),
            ),
            bottomNavigationBar:BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: c.currentIndex,
              onTap: (index){
                      c.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived'
                ),

              ],
            ) ,
          );
        },
      ),
    );
  }

  // Future<String> getName() async{
  //   return 'Basma MOhamed';
  // }
  


}
