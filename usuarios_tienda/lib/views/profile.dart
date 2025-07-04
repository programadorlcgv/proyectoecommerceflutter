import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usuarios_tienda/controllers/auth_service.dart';
import 'package:usuarios_tienda/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),),
      body: Column(
        children: [
          Consumer<UserProvider>( 
            builder: (BuildContext context, UserProvider value, Widget? child) =>
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(value.name),
                  subtitle: Text(value.email),
                  onTap: (){
                  Navigator.pushNamed(context, "/update_profile");
                },
                trailing: Icon(Icons.edit_outlined),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          ListTile(title: Text("Ordenes"), leading: Icon(Icons.local_shipping_outlined), onTap: ()async{
      
      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
          ListTile(title: Text("Descuentos y Ofertas"), leading: Icon(Icons.discount_outlined), onTap: ()async{
      
      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
          ListTile(title: Text("Ayuda y Soporte"), leading: Icon(Icons.support_agent), onTap: ()async{
      
      },),
          Divider( thickness: 1,  endIndent:  10, indent: 10,),
          ListTile(title: Text("Cerrar Sesión"), leading: Icon(Icons.logout_outlined), onTap: ()async{
       await AuthService().logout();
       Navigator.pushNamedAndRemoveUntil(context,"/login", (route)=> true);
      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
        ],
      ),
    );
  }
}