
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:ricardo_app/bloc/ricardo_cubit.dart';
import 'package:ricardo_app/bloc/ricardo_state.dart';
import 'package:ricardo_app/model/product_model.dart';


class SearchScreen extends StatelessWidget {
   SearchScreen({Key? key}) : super(key: key);
  var searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RicardoCubit,RicardoState>(
        //bloc: RicardoCubit.get(context)..getSearchProduct(search),
        builder: (context,state){
          var cubit=RicardoCubit.get(context);
          List<ProductModel> searchProduct=cubit.searchProduct;
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.grey.shade900,
              backgroundColor: Colors.white,
              elevation: 5,
              leading: IconButton(
                onPressed: (){
                  searchController.clear();
                  cubit.searchProduct=[];
                  Navigator.pop(context);
                },
                icon: const Icon(IconlyLight.arrow_left_2),
              ),
              centerTitle: true,
              title:  Text('Search Products',
                  style: TextStyle(
                      fontSize: 22,color: Colors.grey.shade900, fontWeight: FontWeight.bold
                  )),
            ),
            body: Column(
              children: [
                TextField(
                  controller: searchController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  onChanged: (searchName) {
                    cubit.getSearchProduct(searchName);
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.red,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    )
                        : null,
                    hintText: "search",
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(child: searchProduct.isNotEmpty?
                GridView.builder(
                    itemCount: cubit.searchProduct.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) =>
                        Padding(
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
                                    child: Image.network(searchProduct[index].images[0],
                                        width: double.infinity,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 5),
                                    child: Text(searchProduct[index].name,
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
                                      Text(searchProduct[index].price,
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
                                      Text(searchProduct[index].address,
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
                        )
                ):
                Center(
                  child: Text('Empty Product',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                          fontSize: 22
                      )),
                )),
              ],
            )
            ,
          );
        },
        listener: (context, state){

        });
  }
}
