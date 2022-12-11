
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/bloc/ricardo_state.dart';
import 'package:ricardo_app/model/product_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsProduct extends StatelessWidget {
  final ProductModel productModel;
   DetailsProduct({Key? key, required this.productModel}) : super(key: key);
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RicardoCubit,RicardoState>(
        builder: (context,state){
          var cubit=RicardoCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.grey.shade900,
              backgroundColor: Colors.white,
              elevation: 5,
              title:  Text('Details Product',
                  style: TextStyle(
                      fontSize: 22,color: Colors.grey.shade900, fontWeight: FontWeight.bold
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: productModel.images.length,
                        carouselController: carouselController,
                        options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            autoPlayInterval: const Duration(seconds: 2),
                            viewportFraction: 1,
                            onPageChanged: (index, reson) {
                              cubit.changeIndexDetails(index);
                            }),
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(productModel.images[index]),
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
                          activeIndex: cubit.currentIndexDetails,
                          count: productModel.images.length,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: Colors.blue,
                            dotColor: Colors.black,
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(productModel.name,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(productModel.price,
                        style:  TextStyle(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Product Created By : ',
                          style:  TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(productModel.createdBy,
                        style:  TextStyle(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(productModel.desc,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style:  const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Address',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              productModel.address,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                                primary: Colors.blue,
                              ),
                              onPressed: () {
                                FlutterPhoneDirectCaller.callNumber(productModel.phoneNumber);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  const[
                                  Text(
                                    'Call',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.call,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        },
        listener: (context,state){

        });
  }
}
