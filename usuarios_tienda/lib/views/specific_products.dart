
import 'package:flutter/material.dart';
import 'package:usuarios_tienda/contants/discount.dart';
import 'package:usuarios_tienda/controllers/db_service.dart';
import 'package:usuarios_tienda/models/products_model.dart';

class SpecificProducts extends StatefulWidget {
  const SpecificProducts({super.key});

  @override
  State<SpecificProducts> createState() => _SpecificProductsState();
}

class _SpecificProductsState extends State<SpecificProducts> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
  forceMaterialTransparency: true,
        title: Text(
            "${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)} "),
      ),
      body: StreamBuilder(
        stream: DbService().readProducts(args["name"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductsModel> products =
                ProductsModel.fromJsonList(snapshot.data!.docs)
                    as List<ProductsModel>;
            if (products.isEmpty) {
              return Center(
                child: Text("No se encontraron Productos"),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 8.0, // Space between items horizontally
                  mainAxisSpacing: 8.0, // Space between items vertically
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context,"/view_product",arguments: product);
                    },
                    child: Card(
                      color: Colors.grey.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: NetworkImage(product.image),
                                        fit: BoxFit.fitHeight)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Column(
                              children: [
                                 SizedBox(width: 2,),
                          Row(
                            
                            children: [
                          Text("\$${product.old_price}",style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w500, decoration:  TextDecoration.lineThrough),),
                          SizedBox(width: 4,),
                          Text("\$${product.new_price}",style:  TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                          SizedBox(width: 2,),
                                      Text("-${discountPercent(product.old_price,product.new_price)}%",style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.green),),
                            ],
                          )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
