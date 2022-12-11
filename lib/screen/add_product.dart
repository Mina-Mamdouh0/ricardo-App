
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/bloc/ricardo_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../shared/companet.dart';

class AddProduct extends StatelessWidget {
   AddProduct({Key? key}) : super(key: key);

  var nameController=TextEditingController();
  var descController=TextEditingController(text: '');
  var priceController=TextEditingController();
  var addressController=TextEditingController(text: 'Cairo');
  var ageController=TextEditingController(text: '00');
  CarouselController carouselController = CarouselController();
  List<String> items=['Cairo','Giza'];

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RicardoCubit,RicardoState>(
        builder: (context,state){
          var cubit=RicardoCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.grey.shade900,
              backgroundColor: Colors.white,
              leading: (state is LoadingUpdateProduct||state is LoadingImagesProduct)?
              Container():
              IconButton(
                 onPressed: (){
                   RicardoCubit.get(context).picked=null;
                   nameController.clear();
                   descController.clear();
                   priceController.clear();
                   ageController.clear();
                   Navigator.pop(context);
                   RicardoCubit.get(context).getAllProducts();
                 },
                icon: const Icon(IconlyLight.arrow_left_2),
              ),
              elevation: 5,
              title:  Text('Add Product',
                  style: TextStyle(
                      fontSize: 22,color: Colors.grey.shade900, fontWeight: FontWeight.bold
                  )),
                actions: [
                  (state is LoadingUpdateProduct)?
                  const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  Center(child:  CircularProgressIndicator()),
                  ):
                  textButton(
                      text: 'Update',
                      onPress: (){
                        if(nameController.text.isEmpty|| priceController.text.isEmpty||
                            cubit.phoneController.text.isEmpty|| addressController.text.isEmpty)
                        {
                          showToast(msg: 'Please fill date', color: Colors.red);
                        }else{
                          if(cubit.picked==null){
                            showToast(msg: 'Please Pic images', color: Colors.red);
                          } else{
                             cubit.updateProduct(
                                address: addressController.text,
                                name: nameController.text,
                                desc: descController.text,
                                price: priceController.text,
                                age: ageController.text,
                            );

                          }
                        }
                      }
                  )
                ]
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (cubit.picked==null|| cubit.picked!.isEmpty)?
                    Container():
                    Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: cubit.picked!.length,
                          carouselController: carouselController,
                          options: CarouselOptions(
                              height: 250,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              autoPlayInterval: const Duration(seconds: 2),
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                cubit.changeIndexAdd(index);
                              }
                              ),
                          itemBuilder: (context, index, realIndex) {
                            return Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(cubit.picked![index].path)),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 30,
                          left: 180,
                          child: AnimatedSmoothIndicator(
                            activeIndex: cubit.currentIndexAdd,
                            count: cubit.picked!.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: Colors.blue,
                              dotColor: Colors.black,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 180,
                          child: IconButton(
                            onPressed: (){
                              cubit.removeImage(cubit.currentIndexAdd);
                            },
                            icon:const Icon(Icons.clear),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    OutlinedButton(
                      onPressed: (){
                        cubit.pikedImagesProduct();
                      },
                      child: Row(
                        children: const[
                          Spacer(),
                          Icon(IconlyLight.camera),
                          SizedBox(width: 5,),
                          Text('Choose Images',
                              style: TextStyle(
                                  fontSize: 20,color: Colors.blue,
                                  fontWeight: FontWeight.normal
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    defaultTextFiled(
                      controller: nameController,
                      inputType: TextInputType.text,
                      labelText: 'Name',
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter The Name';
                        }
                      },
                      prefixIcon: IconlyLight.profile,
                    ),
                    const SizedBox(height: 8,),
                    defaultTextFiled(
                      controller: descController,
                      inputType: TextInputType.text,
                      labelText: 'Desc',
                      maxLine: 6,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter The Bio';
                        }
                      },
                      prefixIcon: IconlyLight.folder,
                    ),
                    const SizedBox(height: 8,),
                    defaultTextFiled(
                      controller: cubit.phoneController,
                      inputType: TextInputType.phone,
                      labelText: 'Phone',
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter The Phone';
                        }
                      },
                      prefixIcon: IconlyLight.call,
                    ),
                    const SizedBox(height: 8,),
                    defaultTextFiled(
                      controller: priceController,
                      inputType: TextInputType.phone,
                      labelText: 'Price',
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter The Price';
                        }
                      },
                      prefixIcon: Icons.price_change,
                    ),
                    const SizedBox(height: 8,),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Address',
                        contentPadding:const  EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.blue,width: 5),
                        ),
                          prefixIcon: const Icon(Icons.home),
                      ),
                      items:
                      [
                        ...items.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        addressController.text=value.toString();
                      },
                      value: 'Cairo',
                    ),
                    const SizedBox(height: 8,),
                    defaultTextFiled(
                      controller:ageController,
                      inputType: TextInputType.phone,
                      labelText: 'Age',
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter The Age';
                        }
                      },
                      prefixIcon: Icons.data_usage,
                    ),

                  ],
                ),
              ),
            ),
          );
        },
        listener: (context,state){
          if(state is SuccessUpdateProduct){
            RicardoCubit.get(context).picked=null;
            nameController.clear();
            descController.clear();
            priceController.clear();
            ageController.clear();
            Navigator.pop(context);
            RicardoCubit.get(context).getAllProducts();
            //RicardoCubit.get(context).getMyProduct();
          }

        });
  }
}
