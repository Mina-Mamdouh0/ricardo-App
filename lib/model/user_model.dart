class UserModel{
  final String profile;
  final String uId;
  final String name;
  final String email;
  final String phone;
  final String password;


  UserModel({required this.name,required this.email,required this.phone,required this.uId,required this.password,required this.profile });

  factory UserModel.formJson(Map<String, dynamic> json,){
     return UserModel(
        name: json['Name'],
        email:json['Email'],
        phone: json['Phone'],
        uId: json['Id'],
       password:json['Password'] ,
       profile: json['Profile'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'Name': name,
      'Email':email,
      'Phone': phone,
      'Id': uId,
      'Profile': profile,
      'Password':password
    };

  }
}