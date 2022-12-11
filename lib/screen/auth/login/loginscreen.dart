
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ricardo_app/screen/auth/login/bloc/cubit_login.dart';
import 'package:ricardo_app/screen/auth/login/bloc/state_login.dart';

import 'package:ricardo_app/screen/auth/signup/signup_screen.dart';
import 'package:ricardo_app/screen/home_screen.dart';
import 'package:ricardo_app/shared/companet.dart';


class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
   var formKey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(_)=>LoginCubit(),
        child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
    if(state is SuccessLoginScreen){
    navigatorAndRemove(context: context,widget: const HomeScreen());

    }
    else if (state is ErrorLoginScreen){
    showToast(color: Colors.red,msg: 'Check in email and password again');
    }
    },
      builder: (context,state){
        var cubit=LoginCubit.get(context);
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
                        Text('Login',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black
                          ),),
                        const SizedBox(height: 15,),
                        Text('Login now with Ricardo',
                            style: Theme.of(context).textTheme.headline5),
                        const SizedBox(height: 25,),
                        defaultTextFiled(
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          labelText: 'Email Address',
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please Enter The Correct The Email';
                            }
                          },
                          prefixIcon: Icons.person,
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
                            suffixIcon: cubit.obscureText?Icons.visibility:Icons.visibility_off,
                            fctSuffixIcon: ()=>cubit.visiblePassword(),
                            obscureText: cubit.obscureText
                        ),
                        const SizedBox(height: 25,),
                        (state is! LoadingLoginScreen)?
                        MaterialButton(
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              cubit.userLogin(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                context: context
                              );
                            }
                          },
                          minWidth: double.infinity,
                          color: Colors.blue,
                          textColor: Colors.white,
                          height: 50,
                          child:  const Text('Login',style: TextStyle(
                              fontSize: 20
                          ),),
                        ):
                        const Center(child:CircularProgressIndicator()),
                        const SizedBox(height: 15,),
                        Row(
                          children: [
                            const Text('Don\'t have a account?',
                              style: TextStyle(fontSize: 16
                              ),),
                            useTextButton(name: 'Register',
                                onPress: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen())))
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
    ),
    );
  }
}


