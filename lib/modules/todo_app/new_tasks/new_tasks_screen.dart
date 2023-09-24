
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/component.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){} ,
      builder: (context,state){
       var tasks=AppCubit.get(context).newTasks;
       return  ConditionalBuilder(
         condition: tasks.length>0,
         builder: (BuildContext context) => ListView.separated(
           itemBuilder: (context,index)=>buildTasksItem(tasks[index],context),
           separatorBuilder: (context,index)=>Container(
             width: double.infinity,
             height: 1,
             color: Colors.grey[300],
           ),
           itemCount: tasks.length,
         ),
         fallback: (BuildContext context) => Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(
               Icons.menu,
               size: 100,
               color:Colors.grey ,
             ),
             Text(
               'No Tasks Created Yet, Please Add New Tasks',
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 15,
                 color:Colors.grey ,
               ),
             ),
           ],
         ),
       ),
       );
      },
    );
  }
}
