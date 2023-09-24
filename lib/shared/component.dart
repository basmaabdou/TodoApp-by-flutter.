import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cubit/cubit.dart';

Widget defaultButton({
   double width=double.infinity,
   Color background=Colors.blue,
   bool isUpperCase=true,
   double raduis=0.0,
   required final function,
   required String text,
})=>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text ,
          style: TextStyle(
            color: Colors.white,
      ),
    ),
  ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        color: background,
      ),
);

Widget defaultTextForm({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword=false,
  required String labelText,
  required final validate,
  required IconData prefix,
  final  suffixPressed,
  final onChanged,
  final onSubmit,
  final suffix,
  final onTap,
  bool isEnabled=true,
})=>TextFormField(
  controller: controller,
  keyboardType: type,
  onChanged:onChanged ,
  onFieldSubmitted: onSubmit,
  validator: validate,
  obscureText: isPassword,
  onTap: onTap,
  enabled: isEnabled,

  decoration: InputDecoration(
    labelText: labelText,
    border: OutlineInputBorder(),
    prefixIcon: Icon(
        prefix
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
          suffix
      ),
    ) : null,

  ),

);

Widget defaultTextButton({
  required final  function ,
  required String text
})=>TextButton(
    onPressed: function,
    child: Text(text.toUpperCase())
);

Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(start: 10,end: 10),
  child:   Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  ),
);

Widget buildTasksItem(Map model ,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(
              '${model['time']}'
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${model['title']}',
                  maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    // fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20,),
        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            },
            icon:Icon (Icons.check_box,color: Colors.blue,)
        ),
        SizedBox(width: 20,),
        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'archive', id: model['id']);
            },
            icon:Icon (Icons.archive,color:Colors.black54 ,)
        ),
      ],
    ),
  ),
 onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
 },

);

Widget buildTasksEmpty({required List<Map> tasks})=> ConditionalBuilder(
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



//to navigate between screen
void navigateTo(context,Widget)=>Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=>Widget)
);

void navigateFinish(context,Widget)=>Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=>Widget),
    (route) => false
);

void messageToast({
  required String msg,
  required ToastStates state
})=>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ChooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0
        );

enum ToastStates{SUCCESS,ERROR,WARNING}

Color ChooseToastColor(ToastStates state){
  Color color;

  switch(state){
    case ToastStates.SUCCESS:
      color=Colors.green;
      break;
    case ToastStates.ERROR:
      color=Colors.red;
      break;
    case ToastStates.WARNING:
      color=Colors.amber;
      break;
  }
  return color;

}




