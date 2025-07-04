import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/coupon_model.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cupones"),
      ),
      body: StreamBuilder(
        stream: DbService().readCouponCode(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> coupons =
                CouponModel.fromJsonList(snapshot.data!.docs)
                    as List<CouponModel>;

            if (coupons.isEmpty) {
              return Center(
                child: Text("No se encontraron cupones"),
              );
            } else {
              return ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("¿Qué quieres hacer?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AdditionalConfirm(
                                                  contentText:
                                                      "La eliminación no se puede deshacer",
                                                  onNo: () {
                                                    Navigator.pop(context);
                                                  },
                                                  onYes: () {
                                                    DbService()
                                                        .deleteCouponCode(
                                                            docId:
                                                                coupons[index]
                                                                    .id);
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                      },
                                      child: Text("Eliminar cupón")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) => ModifyCoupon(
                                                id: coupons[index].id,
                                                code: coupons[index].code,
                                                desc: coupons[index].desc,
                                                discount:
                                                    coupons[index].discount));
                                      },
                                      child: Text("Actualizar cupón")),
                                ],
                              ));
                    },
                    title: Text(coupons[index].code),
                    subtitle: Text(coupons[index].desc),
                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => ModifyCoupon(
                                id: coupons[index].id,
                                code: coupons[index].code,
                                desc: coupons[index].desc,
                                discount: coupons[index].discount));
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  ModifyCoupon(id: "", code: "", desc: "", discount: 0));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyCoupon extends StatefulWidget {
  final String id, code, desc;
  final int discount;
  const ModifyCoupon(
      {super.key,
      required this.id,
      required this.code,
      required this.desc,
      required this.discount});

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController disPercentController = TextEditingController();

  @override
  void initState() {
    descController.text = widget.desc;
    codeController.text = widget.code;
    disPercentController.text = widget.discount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.id.isNotEmpty ? "Actualizar cupón" : "Añadir cupón"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Todo se convertirá a mayúsculas."),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: codeController,
                validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                decoration: InputDecoration(
                    hintText: "Código de cupón",
                    label: Text("Código de cupón"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
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
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: disPercentController,
                validator: (v) => v!.isEmpty ? "Esto no puede estar vacío." : null,
                decoration: InputDecoration(
                    hintText: "Descuento % ",
                    label: Text("Descuento % "),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true),
                keyboardType: TextInputType.number,
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
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                var data = {
                  "code": codeController.text.toUpperCase(),
                  "desc": descController.text,
                  "discount": int.parse(disPercentController.text)
                };

                if (widget.id.isNotEmpty) {
                  DbService().updateCouponCode(docId: widget.id, data: data);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Código de cupón actualizado.")));
                } else {
                  DbService().createCouponCode(data: data);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Código de cupón añadido.")));
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.id.isNotEmpty ? "Actualizar cupón" : "Añadir cupón")),
      ],
    );
  }
}
