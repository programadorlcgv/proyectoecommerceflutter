import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
import 'package:ecommerce_admin_app/containers/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Panel de administración"),
      actions: [
        IconButton(onPressed: ()async{
          Provider.of<AdminProvider>(context,listen: false).cancelProvider();
         await AuthService().logout();
          Navigator.pushNamedAndRemoveUntil(context, "/login",  (route)=> false);
        }, icon: Icon(Icons.logout))
      ],
      ),
      body:  SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 260,
          padding:  EdgeInsets.all(12),
          margin:  EdgeInsets.only(left: 10,right:  10,bottom: 10),
          decoration:  BoxDecoration(color:  Colors.deepPurple.shade100,borderRadius:  BorderRadius.circular(10)),
            child: Consumer<AdminProvider>(
              builder: (context, value, child) => 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardText(keyword: "Total de las Categorías", value: "${value.categories.length}",),
                  DashboardText(keyword: "Total de los productos", value: "${value.products.length}",),
                  DashboardText(keyword: "Total de las ordenes", value: "${value.totalOrders}",),
                  DashboardText(keyword: "Pedido aún no enviado", value: "${value.orderPendingProcess}",),
                  DashboardText(keyword: "Pedido enviado", value: "${value.ordersOnTheWay}",),
                  DashboardText(keyword: "Pedido entregado", value: "${value.ordersDelivered}",),
                  DashboardText(keyword: "Pedido cancelado", value: "${value.ordersCancelled}",),
                 
                ],
              ),
            )),
        
            // Buttons for admins
            Row(
        children: [
          HomeButton(onTap: (){
            Navigator.pushNamed(context,"/orders");
          }, name: "Pedidos"),
          HomeButton(onTap: (){
            Navigator.pushNamed(context,"/products");
          }, name: "Productos"),
        ],
            ),
            Row(
        children: [
          HomeButton(onTap: (){
            Navigator.pushNamed(context,"/promos",arguments: {"promo":true});
          }, name: "Promos"),
          HomeButton(onTap: (){
             Navigator.pushNamed(context,"/promos",arguments: {"promo":false});
          }, name: "Banners"),
        ],
            ),
            Row(
        children: [
          HomeButton(onTap: (){
            Navigator.pushNamed(context,"/category");
          }, name: "Categorías"),
          HomeButton(onTap: (){
            Navigator.pushNamed(context, "/coupons");
          }, name: "Cupones"),
        ],
            ),
        ],),
      ),
    );
  }
}