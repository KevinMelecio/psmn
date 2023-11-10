import 'package:flutter/material.dart';
import 'package:pmsn20232/components/my_textfield.dart';
import 'package:pmsn20232/firebase/email_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final emailAuth = EmailAuth();
  @override
  void initState() {
    super.initState();
    _checkRememberMeStatus();
  }

  void _checkRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('isLoggedIn') ?? false;
    if (rememberMe) {
      setState(() {
        rememberMe = true;
      });
    }
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setBool('rememberMe', true);
    } else {
      prefs.remove('rememberMe');
    }
    //Redirigir a la pantalla principal
    Navigator.pushNamed(context, '/dash');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController txtConUser = TextEditingController();
    TextEditingController txtConPass = TextEditingController();
    final txtUser = TextField(
      controller: txtConUser,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final txtPass = TextField(
      controller: txtConPass,
      obscureText: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final imgLogo = Container(
      width: 200,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://th.bing.com/th/id/R.3b0e6b71487bf1445034d46eef5d0209?rik=jfGbLN9kQpMbAA&pid=ImgRaw&r=0'))),
    );

    final btnEntrar = FloatingActionButton.extended(
        icon: Icon(Icons.login),
        label: Text('Entrar'),
        onPressed: () {
          _login();
        }
        // onPressed: () async{
        //   bool res = await emailAuth.validateUser(emailUser: txtConUser.text, pwdUser: txtConPass.text);
        //   if(res){
        //     Navigator.pushNamed(context, '/dash');
        //   }

        // }
        );

    return Scaffold(
        resizeToAvoidBottomInset:
            false, //para que pueda dimensionarse y no afecte el teclado de la pantalla
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    // color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: txtConUser,
                  hintText: 'Username',
                  obscureText: false,
                  textColor: Colors.black,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: txtConPass,
                  hintText: 'Password',
                  obscureText: true,
                  textColor: Colors.black,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                            print(value);
                          });
                        }),
                    Text('Recordarme'),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Registrarse :)',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                btnEntrar
                // MaterialButton(
                //     color: Colors.black,
                //     child: Text(
                //       "Sign In",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 16),
                //     ),
                //     onPressed: _login),
              ],
            ),
          ),
        ));

    // return Scaffold(
    //   body: Container(
    //     height: MediaQuery.of(context).size.height,
    //     decoration: const BoxDecoration(
    //         image: DecorationImage(
    //             opacity: .7,
    //             fit: BoxFit.cover,
    //             image: NetworkImage(
    //                 'https://th.bing.com/th/id/R.cc7c0fc167cbdc340c0e2ba15739b314?rik=i0btkLlWk3YXTw&pid=ImgRaw&r=0'))),
    //     child: Padding(
    //       padding: const EdgeInsets.only(bottom: 100.0),
    //       child: Stack(alignment: Alignment.bottomCenter, children: [
    //         Container(
    //           height: 200,
    //           // color: Colors.grey,
    //           margin: const EdgeInsets.symmetric(horizontal: 30),
    //           padding: const EdgeInsets.all(30),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(20),
    //               color: Colors.blueGrey),
    //           child: Column(
    //             children: [
    //               txtUser,
    //               const SizedBox(
    //                 height: 10,
    //               ),
    //               txtPass,
    //             ],
    //           ),
    //         ),
    //         imgLogo,
    //         TextButton(
    //             onPressed: () async {
    //               bool res = await emailAuth.validateUser(
    //                   emailUser: txtConUser.text, pwdUser: txtConPass.text);
    //               if (res) {
    //                 Navigator.pushNamed(context, '/dash');
    //               }
    //             },
    //             child: Text(
    //               'Registrarse :)',
    //               style: TextStyle(
    //                 fontSize: 20,
    //               ),
    //             ))
    //       ]),
    //     ),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   floatingActionButton: btnEntrar,
    // );
  }
}
