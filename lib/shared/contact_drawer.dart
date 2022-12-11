
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/bloc/ricardo_state.dart';
import 'package:ricardo_app/model/user_model.dart';
import 'package:ricardo_app/screen/auth/login/loginscreen.dart';
import 'package:ricardo_app/shared/companet.dart';

import '../screen/my_orders.dart';

class ContactDrawer extends StatelessWidget {
   ContactDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RicardoCubit,RicardoState>(
        builder: (context, state){
          var cubit=RicardoCubit.get(context);
          return Drawer(
            backgroundColor:Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children:  [
                  DrawerHeader(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(cubit.userModel!.profile),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cubit.userModel!.name,
                                style: const TextStyle(
                                  fontSize:22 ,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(cubit.userModel!.phone,
                                style:  TextStyle(
                                  fontSize:18 ,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  const SizedBox(height: 5,),
                  BuildListTile(
                    text: 'Home',
                    icons: Icons.home,
                    onTap: (){},
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 15,
                    indent: 2,
                    thickness: 1,
                  ),

                  BuildListTile(
                    text: 'My Older',
                    icons: Icons.shopping_cart,
                    onTap: (){
                      navigatorPush(context: context, widget: const MyOrder());
                    },
                  ),

                  const Divider(
                    color: Colors.grey,
                    height: 15,
                    indent: 2,
                    thickness: 1,
                  ),
                  BuildListTile(
                    text: 'My Salary',
                    icons: Icons.money,
                    onTap: (){},
                  ),

                  const Divider(
                    color: Colors.grey,
                    height: 15,
                    indent: 2,
                    thickness: 1,
                  ),
                  BuildListTile(
                    text: 'Logout',
                    icons: Icons.logout,
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:const  [
                                  Icon(Icons.logout,color: Colors.deepPurpleAccent,),
                                  SizedBox(width: 5,),
                                  Text('Sign out',style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic
                                  ),),
                                ],
                              ),
                              content:const Text('Do you wanna Sign out ? ',
                                style: TextStyle(
                                    fontSize: 15
                                ),),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.canPop(context)?Navigator.pop(context):null;
                                },
                                    child:const Text('Cancel',
                                      style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                      ),)),
                                TextButton(onPressed: (){
                                  cubit.signOut();
                                },
                                    child:const Text('ok',
                                      style: TextStyle(
                                          color: Colors.red
                                      ),))
                              ],
                            );
          });

          }
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state){
          if(state is SignOutState){
            navigatorAndRemove(context: context, widget: LoginScreen());
            //RicardoCubit.get(context).
          }

        });
  }
}

class BuildListTile extends StatelessWidget {
  final String text;
  final IconData icons;
  final Function() onTap;
  const BuildListTile({Key? key,
    required this.text,
    required this.icons,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),

      ),
      leading:  Icon(icons,
        color: Colors.grey,
        size: 27,),
      onTap: onTap,

    );
  }
}
