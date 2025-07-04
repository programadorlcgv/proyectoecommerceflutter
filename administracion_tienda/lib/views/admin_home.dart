import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
import 'package:ecommerce_admin_app/containers/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel de Administración"),
        actions: [
          IconButton(onPressed: (){
            AuthService().logout();
            Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
          }, icon: Icon(Icons.logout))
        ],
      ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 235,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            decoration: BoxDecoration(color: Colors.deepPurple.shade100, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardText(keyword: "Total de Productos ", value: "Por definir"),
                DashboardText(keyword: "Total de Productos ", value: "Por definir"),
                DashboardText(keyword: "Total de Productos ", value: "Por definir"),
                DashboardText(keyword: "Total de Productos ", value: "Por definir"),
                DashboardText(keyword: "Total de Productos ", value: "Por definir"),
      
              ],
            )
          ),
        // Buttones para admins
        Row(
          children: [
            HomeButton(name: "Ordenes", onTap: () {}),
            HomeButton(name: "Productos", onTap: () {
              Navigator.pushNamed(context, "/products");
            }),
      
          ],
        ),
        Row(
          children: [
            HomeButton(name: "Promos", onTap: () {
              Navigator.pushNamed(context,"/promos",arguments: {"promo":true});
            }),
            HomeButton(name: "Banners", onTap: () {
              Navigator.pushNamed(context,"/promos",arguments: {"promo":false});
            }),
      
          ],
        ),
        Row(
          children: [
            HomeButton(name: "Categorías", onTap: () {
              Navigator.pushNamed(context, "/category");
            }),
            HomeButton(name: "Cupones", onTap: () {
              Navigator.pushNamed(context, "/coupons");
            }),
      
          ],
        ),
        ],
      ),
    ),
    );
  }
}