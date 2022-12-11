
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ricardo_app/bloc/ricardo_state.dart';
import 'package:ricardo_app/model/product_model.dart';
import 'package:ricardo_app/model/user_model.dart';
import 'package:uuid/uuid.dart';

class RicardoCubit extends Cubit<RicardoState>{
  RicardoCubit() : super(InitialState());

  static RicardoCubit get(context)=>BlocProvider.of(context);

  String userId=FirebaseAuth.instance.currentUser!.uid;
  UserModel? userModel;
  var phoneController=TextEditingController();
  int currentIndexAdd = 0;
  int currentIndexDetails = 0;
  List<XFile>? picked;

  List<ProductModel> productsList=[];
  List<ProductModel> myProduct=[];
  List<ProductModel> searchProduct=[];

  void getDateUser(){
    emit(LoadingGetUser());
    FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get().
    then((value){
      userModel=UserModel.formJson(value.data()!);
      phoneController.text=value.get('Phone');
      emit(SuccessGetUser());
    }).onError((error,_){
      emit(ErrorGetUser(error.toString()));
    });
  }
  void changeIndexAdd(int index){
    currentIndexAdd=index;
    emit(CurrentIndexAdd());
  }
  void changeIndexDetails(int index){
    currentIndexDetails=index;
    emit(CurrentIndexDetails());
  }

  void pikedImagesProduct()async{
    picked=await multiImagePiker();
    emit(PickedImagesProduct());
  }
  Future<List<XFile>> multiImagePiker()async{
    List<XFile> images=await ImagePicker().pickMultiImage();
    if(images!=null && images.isNotEmpty){
      return images;
    }else{
      return [];
    }
  }
  void removeImage(int index){
    picked!.removeAt(index);
    if(picked!.length==1){
      picked==null;
    }
    emit(RemoveImagesProduct());
  }
  Future<String> uploadImage(XFile image,String kIdProduct)async{
    Reference ref=FirebaseStorage.instance.ref().
    child('ProductsImage/$userId/$kIdProduct/${image.path.split('/').last}');
    final UploadTask uploadTask = ref.putFile(File(image.path));
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    return await taskSnapshot.ref.getDownloadURL();
  }
  Future<List<String>> uploadMultiImage(List<XFile> images,String kIdProduct)async{
    List<String> path=[];
     for(XFile image in images){
      path.add( await uploadImage(image,kIdProduct ));
    }
    return path;
  }

  void updateProduct({
    required String name,
    required String desc,
    required String price,
    String? age,
    required String address,
  })async{
    var kIdProduct = const Uuid().v4();
    emit(LoadingUpdateProduct());
    List<String>imagesProductUrl=await uploadMultiImage(picked!,kIdProduct);
    ProductModel model=ProductModel(
      dateTime: Timestamp.now(),
         address: address,
        images: imagesProductUrl,
        name: name,
        desc: desc,
        phoneNumber: phoneController.text,
        price: price,
        userId: userId,
        idProduct: kIdProduct,
        createdBy: userModel!.name,
        age: age??'00');
    FirebaseFirestore.instance
        .collection('Product').doc(kIdProduct).set(model.toMap()).
    then((value){
      emit(SuccessUpdateProduct());
    }).onError((error,_){
      emit(ErrorUpdateProduct(error.toString()));
    });
  }

  void getAllProducts(){
    productsList=[];
    emit(LoadingGetProducts());
    FirebaseFirestore.instance
        .collection('Product').orderBy('DateTime',descending: true).get().
    then((value){
      for (var element in value.docs) {
        productsList.add(ProductModel.formJson(element.data()));
      }
      emit(SuccessGetProducts());
    }).onError((error,_){
      emit(ErrorGetProducts(error.toString()));
    });
  }
  void getMyProduct(){
    myProduct=[];
    myProduct.addAll(productsList.where((element)=>element.userId==FirebaseAuth.instance.currentUser!.uid));
    emit(GetMyProduct());
    }
  void getSearchProduct(String search) {
    search = search.toLowerCase();
    searchProduct=[];
    searchProduct = productsList.where((product) {
      var searchName = product.name.toLowerCase();
      var searchDesc = product.desc.toLowerCase();
      var searchPrice = product.price.toString().toLowerCase();
      return searchName.contains(search) ||
             searchPrice.toString().contains(search)||
          searchDesc.toString().contains(search);
    }).toList();
    emit(GetSearchProduct());

  }

  void signOut()async{
    await FirebaseAuth.instance.signOut().whenComplete(() {
      emit(SignOutState());
    });

  }

}

