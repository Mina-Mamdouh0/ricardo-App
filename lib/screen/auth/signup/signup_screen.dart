
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/screen/auth/signup/bloc/cubit_signup.dart';
import 'package:ricardo_app/screen/auth/signup/bloc/state_signup.dart';
import 'package:ricardo_app/screen/home_screen.dart';
import 'package:ricardo_app/shared/companet.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  var formKey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var confirmPasswordController=TextEditingController();
  var phoneController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>SignUpCubit(),
        child: BlocConsumer<SignUpCubit,SignUpStates>(
          listener: (context,state){
            if(state is SuccessSignUp){

              navigatorAndRemove(context: context,widget: const HomeScreen());
            }
            else if (state is ErrorSignUp){
              showToast(color: Colors.red,msg: state.error);
            }
            else if (state is ErrorCreateUser){
              showToast(color: Colors.red,msg: 'Dear User please create account again');
            }
          },
          builder: (context,state){
            var cubit=SignUpCubit.get(context);
            return Scaffold(
                body:Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sign Up',
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                  color: Colors.black
                              ),),
                            const SizedBox(height: 15,),
                            Text('Sign Up now with Ricardo',
                                style: Theme.of(context).textTheme.headline5),
                            const SizedBox(height: 25,),
                            Row(
                              children: [
                                Flexible(
                                  child: defaultTextFiled(
                                    controller: nameController,
                                    inputType: TextInputType.text,
                                    labelText: 'Name',
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Please Enter The Name';
                                      }
                                    },
                                    prefixIcon: Icons.person,
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      width:70,
                                      height: kBottomNavigationBarHeight,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: cubit.file==null?
                                        Image.network('https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                                          fit: BoxFit.fill,):
                                        Image.file(File(cubit.file!.path),
                                          fit: BoxFit.fill,),
                                      )
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        showDialog(context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                title:const  Text(
                                                  'Please choose an option',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),

                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: ()async{
                                                        Navigator.pop(context);
                                                        XFile? picked=await ImagePicker().pickImage(source: ImageSource.camera,maxHeight: 1080,maxWidth: 1080);
                                                        if(picked !=null){
                                                          cubit.takeImage(picked);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: const [
                                                            Icon(Icons.photo,color: Colors.purple,),
                                                            SizedBox(width: 10,),
                                                            Text('Camera',
                                                              style: TextStyle(
                                                                  color: Colors.purple,fontSize: 20
                                                              ),)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: ()async{
                                                        Navigator.pop(context);
                                                        XFile? picked=await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 1080,maxWidth: 1080);
                                                        if(picked !=null){
                                                          cubit.takeImage(picked);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: const [
                                                            Icon(Icons.camera,color: Colors.purple,),
                                                            SizedBox(width: 10,),
                                                            Text('Gallery',
                                                              style: TextStyle(
                                                                  color: Colors.purple,fontSize: 20
                                                              ),)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 2,
                                                color: Colors.white),
                                            color: Colors.pink
                                        ),
                                        child: Icon(cubit.file==null?Icons.camera_alt:Icons.edit,
                                          color: Colors.white,
                                          size: 20,),

                                      ),
                                    )
                                  ],
                                )
                              ]
                    ),
                            const SizedBox(height: 15,),
                            defaultTextFiled(
                              controller: emailController,
                              inputType: TextInputType.emailAddress,
                              labelText: 'Email Address',
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Please Enter The Email';
                                }
                              },
                              prefixIcon: Icons.email,
                            ),
                            const SizedBox(height: 15,),
                            defaultTextFiled(
                              controller: passwordController,
                              inputType: TextInputType.visiblePassword,
                              labelText: 'Password',
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Please Password is Shorted';
                                }
                              },
                              prefixIcon: Icons.lock,
                              suffixIcon: SignUpCubit.get(context).obscurePassword?Icons.visibility:Icons.visibility_off,
                                fctSuffixIcon: ()=>SignUpCubit.get(context).visiblePassword(),
                              obscureText: SignUpCubit.get(context).obscurePassword
                            ),

                            const SizedBox(height: 15,),
                            defaultTextFiled(
                                controller: confirmPasswordController,
                                inputType: TextInputType.visiblePassword,
                                labelText: 'Confirm Password',
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Please Password Not True';
                                  }
                                },
                                prefixIcon: Icons.lock,
                                suffixIcon: SignUpCubit.get(context).obscureConfirmPassword?Icons.visibility:Icons.visibility_off,
                                fctSuffixIcon: ()=>SignUpCubit.get(context).visibleConfirmPassword(),
                                obscureText: SignUpCubit.get(context).obscureConfirmPassword
                            ),
                            const SizedBox(height: 15,),
                            defaultTextFiled(
                              controller: phoneController,
                              inputType: TextInputType.phone,
                              labelText: 'Phone Number',
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Please Enter The Phone';
                                }
                              },
                              prefixIcon: Icons.phone,
                            ),
                            const SizedBox(height: 25,),
                            (state is LoadingSignUp || state is LoadingCreateUser)?
                            const Center(child:CircularProgressIndicator())
                            :
                            MaterialButton(
                              onPressed: (){
                                if(formKey.currentState!.validate()){
                                  if(cubit.file==null){
                                    showToast(msg: 'Please Pic Image', color: Colors.red);
                                  }
                                  else{
                                    if(passwordController.text.trim()!=confirmPasswordController.text.trim()){
                                      showToast(msg: 'The password not confirm', color: Colors.red);
                                    }else{
                                     if(phoneController.text.trim().length!=11){
                                       showToast(msg: 'Chick to phone number', color: Colors.red);
                                     }else{
                                       SignUpCubit.get(context).userSignUp(
                                         email: emailController.text.trim(),
                                         password: passwordController.text.trim(),
                                         name: nameController.text.trim(),
                                         phone: phoneController.text.trim(),
                                         context: context);
                                     }
                                    }
                                  }

                                }
                                },
                              minWidth: double.infinity,
                              color: Colors.blue,
                              textColor: Colors.white,
                              height: 50,
                              child:  const Text('Create Account',style: TextStyle(
                                  fontSize: 20
                              ),),
                            ),

                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                const Text('Do have a account?',
                                  style: TextStyle(fontSize: 16
                                  ),),
                                useTextButton(name: 'Login',
                                    onPress: ()=>Navigator.pop(context))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            );
          },
        )
    );
  }
}
