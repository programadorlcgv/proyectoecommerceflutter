import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key:  formKey,
          child: Column(children: [
             SizedBox(
                  height: 120,
                ),
                  SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Iniciar sesión",
                        style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                  Text("Comience a usar su cuenta"),
                  SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "El correo electrónico no puede estar vacío." : null,
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email"),
                      ),
                    )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    child: TextFormField(
                      validator: (value) => value!.length < 8
                          ? "La contraseña debe tener al menos 8 caracteres."
                          : null,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Contraseña"),
                      ),
                    )),
                     SizedBox(
                  height: 10,
                ),
                Row(  mainAxisAlignment: MainAxisAlignment.end,children: [
                  TextButton(onPressed: (){
                  showDialog(context: context, builder:  (builder) {
                  return AlertDialog(
                    title:  Text("Olvidé mi contraseña"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Escribe tu correo electrónico"),
                        SizedBox(height: 10,),
                        TextFormField (controller:  _emailController, decoration: InputDecoration(label: Text("Email"), border: OutlineInputBorder()),),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);}, child: Text("Cancelar")),
                      TextButton(onPressed: ()async{
                        if(_emailController.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("El correo electrónico no puede estar vacío")));
                          return;
                        }
                       await AuthService().resetPassword(_emailController.text).then( (value) {
                        if(value=="Mail Sent"){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("El enlace de restablecimiento de contraseña enviado a su correo electrónico")));
                          Navigator.pop(context);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value,style: TextStyle( color:  Colors.white),), backgroundColor: Colors.red.shade400,));
                        }
                        });
                      }, child: Text("Enviar")),
                    ]

                  );
                });
                  }, child: Text("Olvidé mi contraseña")),
                ],),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ElevatedButton(
                      
                      
                        onPressed: () {
                           if (formKey.currentState!.validate()) {
                              AuthService()
                              .loginWithEmail(
                                  _emailController.text, _passwordController.text)
                              .then((value) {
                            if (value == "Login Successful") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("se ha iniciado Sesión")));
                             Navigator.restorablePushNamedAndRemoveUntil(context, "/home" , (route) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red.shade400,
                              ));
                            }
                          });
                        
                        }
                        },
                        child: Text(
                          "Iniciar sesión",
                          style: TextStyle(fontSize: 16),
                        ))),
          
                        SizedBox(
                  height: 10,
                ),
          
          
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿No tienes una cuenta?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: Text("Registrarse"))
                  ],
                )
               
          ],),
        ),
      ),
    );
  }
}