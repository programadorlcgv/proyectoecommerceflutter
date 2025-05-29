import 'dart:io';

import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/controllers/storage_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;



  // function to pick image using image picker
  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await StorageService().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Imagen cargada exitosamente")));
        }
      });
    }
  }

  // set the data from arguments
  setData(ProductsModel data) {
    productId = data.id;
    nameController.text = data.name;
    oldPriceController.text = data.old_price.toString();
    newPriceController.text = data.new_price.toString();
    quantityController.text = data.maxQuantity.toString();
    categoryController.text = data.category;
    descController.text = data.description;
    imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ProductsModel) {
      setData(arguments);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(productId.isNotEmpty ? "Actualizar producto" : "Agregar producto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  decoration: InputDecoration(
                      hintText: "Escribe un nombre para el producto",
                      label: Text("Nombre del producto"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: oldPriceController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  decoration: InputDecoration(
                    hintText: "Escribe el precio",
                    label: Text("Precio original"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newPriceController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  decoration: InputDecoration(
                    hintText: "Escribe el precio de venta",
                    label: Text("Precio de venta"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: quantityController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  decoration: InputDecoration(
                      hintText: "Cantidad restante",
                      label: Text("Cantidad restante"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Categoria",
                      label: Text("Categoria"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Seleccionar categoría:"),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<AdminProvider>(
                                      builder: (context, value, child) =>
                                          SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: value.categories
                                                  .map((e) => TextButton(
                                                      onPressed: () {
                                                        categoryController
                                                            .text = e["name"];
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(e["name"])))
                                                  .toList(),
                                            ),
                                          ))
                                ],
                              ),
                            ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: descController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  decoration: InputDecoration(
                      hintText: "Descripción",
                      label: Text("Descripción"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                  maxLines: 8,
                ),
                SizedBox(
                  height: 10,
                ),
                image == null
                    ? imageController.text.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.all(20),
                            height: 100,
                            width: double.infinity,
                            color: Colors.deepPurple.shade50,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                            ))
                        : SizedBox()
                    : Container(
                        margin: EdgeInsets.all(20),
                        height: 200,
                        width: double.infinity,
                        color: Colors.deepPurple.shade50,
                        child: Image.file(
                          // File(image!.path),
                          File(image!.path),
                          fit: BoxFit.contain,
                        )),
                ElevatedButton(
                    onPressed: () {

                   pickImage();

                    },
                    child: Text("Seleccionar imagen")),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: imageController,
                  validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                  decoration: InputDecoration(
                      hintText: "Link de la imagen",
                      label: Text("Link de la imagen"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Map<String, dynamic> data = {
                              "name": nameController.text,
                              "old_price": int.parse(oldPriceController.text),
                              "new_price": int.parse(newPriceController.text),
                              "quantity": int.parse(quantityController.text),
                              "category": categoryController.text,
                              "desc": descController.text,
                              "image": imageController.text
                            };

                            if (productId.isNotEmpty) {
                              DbService()
                                  .updateProduct(docId: productId, data: data);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Producto actualizado")));
                            } else {
                              DbService().createProduct(data: data);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Producto añadido")));
                            }
                          }
                        },
                        child: Text(productId.isNotEmpty
                            ? "Actualizar producto"
                            : "Agregar producto")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
