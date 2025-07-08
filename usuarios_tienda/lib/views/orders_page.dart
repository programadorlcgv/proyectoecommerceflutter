
import 'package:flutter/material.dart';
import 'package:usuarios_tienda/containers/additional_confirm.dart';
import 'package:usuarios_tienda/controllers/db_service.dart';
import 'package:usuarios_tienda/models/orders_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget statusIcon(String status) {
    if (status == "PAID") {
      return statusContainer(
          text: "Pagado", bgColor: Colors.lightGreen, textColor: Colors.white);
    }
    if (status == "ON_THE_WAY") {
      return statusContainer(
          text: "En camino", bgColor: Colors.yellow, textColor: Colors.black);
    } else if (status == "DELIVERED") {
      return statusContainer(
          text: "Entregado",
          bgColor: Colors.green.shade700,
          textColor: Colors.white);
    } else {
      return statusContainer(
          text: "Cancelado", bgColor: Colors.red, textColor: Colors.white);
    }
  }

  Widget statusContainer(
      {required String text,
      required Color bgColor,
      required Color textColor}) {
    return Container(
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      color: bgColor,
      padding: EdgeInsets.all(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Compras",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: StreamBuilder(
        stream: DbService().readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrdersModel> orders =
                OrdersModel.fromJsonList(snapshot.data!.docs)
                    as List<OrdersModel>;
            if (orders.isEmpty) {
              return Center(
                child: Text("No se encotró ninguna orden"),
              );
            } else {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/view_order",
                          arguments: orders[index]);
                    },
                    title: Text(
                        "${totalQuantityCalculator(orders[index].products)} producto${totalQuantityCalculator(orders[index].products) > 1 ? "s" : ""} se pago \$ ${orders[index].total}"),
                    subtitle: Text(
                        "Pedido el ${DateTime.fromMillisecondsSinceEpoch(orders[index].created_at).toString()}"),
                    trailing: statusIcon(orders[index].status),
                  );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Resumen del pedido"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Detalles de la entrega",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID del pedido : ${args.id}"),
                    Text(
                        "Pedido el : ${DateTime.fromMillisecondsSinceEpoch(args.created_at).toString()}"),
                    Text("Pedido por : ${args.name}"),
                    Text("Número de teléfono : ${args.phone}"),
                    Text("Dirección de entrega: ${args.address}"),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: args.products
                    .map((e) => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(e.image),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(child: Text(e.name)),
                                ],
                              ),
                              Text(
                                "\$${e.single_price} x ${e.quantity} ${e.quantity > 1 ? 'unidades' : 'unidad'}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "\$${e.total_price.toString()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Descuento  : \$${args.discount}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "Total : \$${args.total}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "Estado : ${args.status}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
          args.status=="PAID" || args.status=="ON_THE_WAY" ? 
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  child: Text("Modificar Pedido"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ModifyOrder(
                              order: args,
                            ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
              ):
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modificar este pedido"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Elige lo que quieres hacer"),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AdditionalConfirm(
                        contentText:
                            "Después de cancelar, esto no se puede cambiar, deberá realizar el pedido nuevamente.",
                        onYes: () async {
                          await DbService().updateOrderStatus(
                              docId: widget.order.id,
                              data: {"status": "CANCELLED"});
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Orden actualizada")));
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onNo: () {
                          Navigator.pop(context);
                        }));
              },
              child: Text("Cancelar Pedido"))
        ],
      ),
    );
  }
}
