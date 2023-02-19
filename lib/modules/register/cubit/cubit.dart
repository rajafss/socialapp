
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/modules/register/cubit/states.dart';

import '../../../modeles/social_user_model.dart';



class SocialRegisterCubit extends Cubit<SocialRegisterState>{

  SocialRegisterCubit(): super(SocialRegisterLoadingState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    @required String? name,
    @required String? email,
    @required String? phone,
    @required String? password
  })
  {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(uId: value.user!.uid,
          name: name,
          email: email,
          phone: phone
      );
    }).catchError((error){
      print(error.toString());
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    @required String? name,
    @required String? email,
    @required String? phone,
    @required String? uId,
    bool? isEmailVerified
  })
  {
    SocialUserModel model = SocialUserModel(name: name!, email: email!, phone: phone!, uId: uId!,isEmailVerified: isEmailVerified!);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).set(model.toMap()).then((value)
    {
      emit(SocialCreateUserSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SocialCreateUserErrorState(error));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordvisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off;

    emit(SocialRegisterChangePasswordVisibilityState());
    throw Exception();

  }

}