import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/component.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){} ,
      builder: (context,state){
        var tasks=AppCubit.get(context).doneTasks;
        return  buildTasksEmpty(tasks: tasks);
      },
    );
  }
}
