import 'package:flutter/material.dart';
import 'package:login_randy/services/auth_services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context){
    //manda llamar la clase authservices
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          //lee el token
          future: authServices.readToken(),
          builder: (
            BuildContext context, 
            AsyncSnapshot<String> snapshot
          ){
            if(!snapshot.hasData) return Text('');
            if(snapshot.hasData == '') {
              Future.microtask((){
                Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(
                    //se pone a fuerza ya que son parametros que se piden pero que no usaremos
                    pageBuilder: (_,__,___)=> 
                    LoginPage(), 
                    transitionDuration: Duration(
                      seconds: 0
                    )
                  ),
                );
              });
            }
          },
        ),
      ),
    );
  }
}