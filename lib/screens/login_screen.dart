import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    TextEditingController txtConUser = TextEditingController();
    TextEditingController txtConPass = TextEditingController();
    final txtUser= TextField(
      controller: txtConUser,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

    final txtPass = TextField(
      controller: txtConPass,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

    final imgLogo = Container(
      width: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://th.bing.com/th/id/R.3b0e6b71487bf1445034d46eef5d0209?rik=jfGbLN9kQpMbAA&pid=ImgRaw&r=0')
        )
      ),
    );

    final btnEntrar = FloatingActionButton.extended(
      icon: Icon(Icons.login),
      label: Text('Entrar'),
      onPressed: () => Navigator.pushNamed(context, '/dash')
      // {
      //   Navigator.pushNamed(context, '/dash');
      // }
    );


    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: .7,
            fit: BoxFit.cover,
            image: NetworkImage('https://th.bing.com/th/id/R.cc7c0fc167cbdc340c0e2ba15739b314?rik=i0btkLlWk3YXTw&pid=ImgRaw&r=0')
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 200,
                // color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey
                ),
                child: Column(
                  children: [
                    txtUser, 
                    const SizedBox(height: 10,),
                    txtPass,
                  ],
                ),
              ),
              imgLogo
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: btnEntrar,
    );
  }
}