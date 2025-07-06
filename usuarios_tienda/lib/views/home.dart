
import 'package:flutter/material.dart';
import 'package:usuarios_tienda/containers/category_container.dart';
import 'package:usuarios_tienda/containers/discount_container.dart';
import 'package:usuarios_tienda/containers/home_page_maker_container.dart';
import 'package:usuarios_tienda/containers/promo_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Las mejores ofertas",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),  scrolledUnderElevation: 0,
  forceMaterialTransparency: true,)
    ,body:SingleChildScrollView(
      child: Column(children: [
        //widgets
        PromoContainer(),
        DiscountContainer(),
        CategoryContainer(),

        HomePageMakerContainer()
      ],),
    )
    );
  }
}