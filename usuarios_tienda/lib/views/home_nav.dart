
import 'package:flutter/material.dart';
import 'package:usuarios_tienda/views/home.dart';
import 'package:usuarios_tienda/views/profile.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {


  int selectedIndex = 0;

  List pages = [
    HomePage(),
    Text("Ordenes"),
    Text("Carrito"),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex=value;
          });
        },
        selectedItemColor:  Colors.blue,
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              label: 'Ordenes',
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Carrrito',
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Perfil',
            ),
        ],
      ),
    );
  }
}

/*
This is the home navbar of the app
 */