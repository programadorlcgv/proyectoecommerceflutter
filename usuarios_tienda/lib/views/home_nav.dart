
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usuarios_tienda/providers/cart_provider.dart';
import 'package:usuarios_tienda/providers/user_provider.dart';
import 'package:usuarios_tienda/views/cart_page.dart';
import 'package:usuarios_tienda/views/home.dart';
import 'package:usuarios_tienda/views/orders_page.dart';
import 'package:usuarios_tienda/views/profile.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {

  @override
  void initState() {
    Provider.of<UserProvider>(context,listen: false);
    super.initState();
  }

  int selectedIndex = 0;

  List pages = [
    HomePage(),
    OrdersPage(),
    CartPage(),
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
              label: 'Compras',
            ),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, value, child) {
                  if(value.carts.length>0){
                    return Badge(label: Text(value.carts.length.toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                    backgroundColor:  Colors.green.shade400,
                    );
                  }
                  return Icon(Icons.shopping_cart_outlined);
                },
              ),
              label: 'Carrito',
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