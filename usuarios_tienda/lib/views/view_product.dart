
import 'package:flutter/material.dart';
import 'package:usuarios_tienda/contants/discount.dart';
import 'package:usuarios_tienda/models/products_model.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductsModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del producto"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              arguments.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    arguments.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                   
                      Text(
                        "\$ ${arguments.old_price}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "\$ ${arguments.new_price}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            ),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_downward, color: Colors.green,
                          size: 20,),
                      Text("${discountPercent(arguments.old_price, arguments.new_price)} %",
                       style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),)
                    ],
                  ),
        
                  SizedBox(
                    height: 10,
                  ),
                  arguments.maxQuantity == 0
                        ? Text(
                            "Agotado",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          )
                        : Text(
                            "Solo quedan ${arguments.maxQuantity} en stock",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(arguments.description,
                   style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700),)
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:  Row(children: [
        
SizedBox(
  height: 60,width: MediaQuery.of(context).size.width*.5,
  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Añadir al carrito"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder()),
                  ),
),
SizedBox(
  height: 60,width: MediaQuery.of(context).size.width*.5,
  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Comprar ahora"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:  Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder()),
                  ),
),
      ],),
    );
  }
}
