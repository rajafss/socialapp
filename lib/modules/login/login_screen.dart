
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/component.dart';
import '../../layout/home_Layout_screen.dart';
import '../../network/local/cache_helper.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    var emailControler = TextEditingController();
    var passwordControler = TextEditingController();
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginState>(
        listener: (context, state)
        {
          if(state is SocialLoginErrorState)
          {
            print(state.error.toString());
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 6,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }

          if(state is SocialLoginSuccessState)
          {
            CacheHelper.saveToken(
                key: 'uId',
                value: state.uId
            ).then((value)
            {
              navigateAndFinish(context, HomeLayoutScreen());
            });
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN',
                            style: Theme.of(context).textTheme.headline4?.copyWith(
                                color: Colors.black
                            )),
                        Text('login now to browse our hot offers',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.black26
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailControler,
                          validator: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your email address';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordControler,

                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'please enter your password';
                            }
                          },

                          obscureText: SocialLoginCubit.get(context).isPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed:()
                              {
                                SocialLoginCubit.get(context).changePasswordvisibility();
                              },
                              icon: Icon(SocialLoginCubit.get(context).suffix),),
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),

                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) =>  Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.pink.shade700,
                            ),
                            child: MaterialButton(
                              onPressed: ()
                              {
                                if(formkey.currentState!.validate())
                                {
                                  SocialLoginCubit.get(context).userLogin(
                                      email: emailControler.text,
                                      password: passwordControler.text);
                                }
                              },
                              child: Text('LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              ),
                            ),
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('don\'t have an accout?'),
                            TextButton(onPressed: (){
                              navigateTo(context, RegisterScreen());
                            },
                              child: Text("Register"),),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

  }
}
