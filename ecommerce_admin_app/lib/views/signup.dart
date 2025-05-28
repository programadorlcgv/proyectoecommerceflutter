import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
    final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                        "Registrarse",
                        style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                  Text("Crea una nueva cuenta y comienza"),
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
               
                SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ElevatedButton(
                      
                      
                        onPressed: () {
                           if (formKey.currentState!.validate()) {
                            AuthService()
                                .createAccountWithEmail(
                                    _emailController.text, _passwordController.text)
                                .then((value) {
                              if (value == "Account Created") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Account Created")));
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
                          "Registrarse",
                          style: TextStyle(fontSize: 16),
                        ))),
          
                        SizedBox(
                  height: 10,
                ),
          
          
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿Ya tienes una cuenta?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Login"))
                  ],
                )
               
          ],),
        ),
      ),
    );
  }
}