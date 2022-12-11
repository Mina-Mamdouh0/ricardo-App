import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  final List images;
  final String name;
  final String desc;
  final String phoneNumber;
  final String price;
  final String age;
  final String userId;
  final String idProduct;
  final String address;
  final String createdBy;
  final Timestamp dateTime;


  ProductModel(
      {required this.images,
        required this.createdBy,
        required this.address,
        required this.dateTime,
        required this.name,
      required this.desc,
      required this.phoneNumber,
      required this.price,
      required this.age,
      required this.userId,
      required this.idProduct});

  factory ProductModel.formJson(Map<String, dynamic> json,){
    return ProductModel(
      address: json['Address'],
      createdBy: json['CreatedBy'],
      dateTime: json['DateTime'],
      images: json['Images'],
      name:json['Name'],
      desc: json['Desc'],
      phoneNumber: json['PhoneNumber'],
      price:json['Price'] ,
      age: json['Age'],
      userId: json['UserId'],
      idProduct: json['IdProduct'],
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'Images': FieldValue.arrayUnion(images),
      'Address':address,
      'DateTime':dateTime,
      'CreatedBy':createdBy,
      'UserId':userId,
      'IdProduct':idProduct,
      'Name':name,
      'Desc': desc,
      'PhoneNumber': phoneNumber,
      'Price': price,
      'Age':age
    };

  }
}


//