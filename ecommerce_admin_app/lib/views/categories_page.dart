import 'dart:io';

import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/controllers/storage_service.dart';
import 'package:ecommerce_admin_app/models/categories_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<CategoriesModel> categories =
              CategoriesModel.fromJsonList(value.categories);

          if (value.categories.isEmpty) {
            return Center(
              child: Text("No se encontraron categorías"),
            );
          }

          return ListView.builder(
            itemCount: value.categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                    height: 50,
                    width: 50,
                    child: Image.network(categories[index].image == null ||
                            categories[index].image == ""
                        ? "https://demofree.sirv.com/nope-not-here.jpg"
                        : categories[index].image)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("¿Qué quieres hacer?"),
                            content: Text("La acción de eliminar no se puede deshacer"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) => AdditionalConfirm(
                                            contentText:
                                                "¿Estás segura de que quieres eliminar esto?",
                                            onYes: () {
                                              DbService().deleteCategories(
                                                  docId: categories[index].id);
                                              Navigator.pop(context);
                                            },
                                            onNo: () {
                                              Navigator.pop(context);
                                            }));
                                  },
                                  child: Text("Eliminar categoría")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) => ModifyCategory(
                                              isUpdating: true,
                                              categoryId: categories[index].id,
                                              priority:
                                                  categories[index].priority,
                                              image: categories[index].image,
                                              name: categories[index].name,
                                            ));
                                  },
                                  child: Text("Actualizar categoría"))
                            ],
                          ));
                },
                title: Text(
                  categories[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Prioridad : ${categories[index].priority}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ModifyCategory(
                              isUpdating: true,
                              categoryId: categories[index].id,
                              priority: categories[index].priority,
                              image: categories[index].image,
                              name: categories[index].name,
                            ));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ModifyCategory(
                    isUpdating: false,
                    categoryId: "",
                    priority: 0,
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory(
      {super.key,
      required this.isUpdating,
      this.name,
      required this.categoryId,
      this.image,
      required this.priority});

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
  }


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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Actualizar categoría" : "Agregar categoría"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Todo se convertirá a minúsculas."),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                decoration: InputDecoration(
                    hintText: "Escribe un nombre para categoría",
                    label: Text("Nombre de la categoría"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Esto se utilizará para ordenar categorías. Mayor el número mas arriba se posiciona"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Escribe un número",
                    label: Text("Prioridad"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
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
                        File(image!.path),
                        fit: BoxFit.contain,
                      )),
              ElevatedButton(
                  onPressed: () {

                    pickImage();
                   
                  },
                  child: Text("Agregar Imagen")),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "Esto no puede estar vacío.." : null,
                decoration: InputDecoration(
                    hintText: "Escribe el link de la imagen",
                    label: Text("Link de la imagen"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (widget.isUpdating) {
                  await DbService()
                      .updateCategories(docId: widget.categoryId, data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text)
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Categoría actualizada"),
                  ));
                } else {
                  await DbService().createCategories(data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text)
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Categoría añadida"),
                  ));
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.isUpdating ? "Actualizar" : "Añadir")),
      ],
    );
  }
}
