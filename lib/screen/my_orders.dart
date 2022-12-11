
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/bloc/ricardo_state.dart';
import 'package:ricardo_app/model/product_model.dart';
import 'package:ricardo_app/screen/details_product.dart';
import 'package:ricardo_app/shared/companet.dart';

class MyOrder extends StatelessWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RicardoCubit,RicardoState>(
      bloc: RicardoCubit.get(context)..getMyProduct(),
        builder: (context,state){
          var cubit=RicardoCubit.get(context);
          List<ProductModel> myProduct=cubit.myProduct;
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.grey.shade900,
              backgroundColor: Colors.white,
              elevation: 5,
              centerTitle: true,
              title:  Text('My Order',
                  style: TextStyle(
                      fontSize: 22,color: Colors.grey.shade900, fontWeight: FontWeight.bold
                  )),
            ),
            body: cubit.myProduct.isNotEmpty?
            GridView.builder(
                itemCount: cubit.myProduct.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: (){
                        navigatorPush(context: context, widget:
                        DetailsProduct(productModel: myProduct[index]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(myProduct[index].images[0],
                                      width: double.infinity,
                                      fit: BoxFit.fill),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 5),
                                  child: Text(myProduct[index].name,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(myProduct[index].price,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.location_on_outlined,
                                        color: Colors.blue,
                                        size: 20),
                                    Text(myProduct[index].address,
                                      maxLines: 2,
                                      style:  const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
            ):
            Center(
              child: Text('Empty Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      fontSize: 22
                  )),
            ),
          );
        },
        listener: (context, state){

        });
  }
}
