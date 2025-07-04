
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usuarios_tienda/controllers/db_service.dart';
import 'package:usuarios_tienda/providers/user_provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    final user=Provider.of<UserProvider>(context,listen: false);
    _nameController.text = user.name;
    _emailController.text = user.email;
    _addressController.text = user.address;
    _phoneController.text = user.phone;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar Perfil"),
          scrolledUnderElevation: 0,
  forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key:  formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Nombre",
                      hintText: "Nombre",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "El nombre no puede estar vacío." : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "El correo electrónico no puede estar vacío" : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 3,
                  controller: _addressController,
                  decoration: InputDecoration(
                      labelText: "Dirección",
                      hintText: "Dirección",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "La dirección no puede estar vacía." : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: "Teléfono",
                      hintText: "Telélfono",
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "El teléfono no puede estar vacío." : null,
                ),
                SizedBox(height: 10,),
                 SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ElevatedButton(
                      
                      
                        onPressed: ()async {
                          if(formKey.currentState!.validate()){
                            var data={
                              "name":_nameController.text,
                              "email":_emailController.text,
                              "address":_addressController.text,
                              "phone":_phoneController.text
                            };
await DbService().updateUserData(extraData: data);
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Perfil actualizado")));

                          }
                          
                        },
                        style:  ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white
                        ),
                        child: Text(
                          "Actualizar perfil",
                          style: TextStyle(fontSize: 16),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
