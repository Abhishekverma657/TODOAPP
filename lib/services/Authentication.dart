 

import 'package:flutter/material.dart';
import 'package:todo/mainhomepage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
 
 class GSignIn extends StatefulWidget {
  const GSignIn({super.key});

  @override
  State<GSignIn> createState() => _GSignInState();
}

class _GSignInState extends State<GSignIn> {
  @override
  Future  googlelogIn() async{
     GoogleSignIn _googlesignIn=GoogleSignIn();
     try{
      var result =await _googlesignIn.signIn();
      if(result==null)
      {
        return;
      }

       final   userData=await result.authentication;
       final Credential=GoogleAuthProvider.credential(
        accessToken: userData.accessToken,idToken: userData.idToken
       );
        final finalresult=await FirebaseAuth.instance.signInWithCredential(Credential);

      }catch(err){
       print(err);
      }

   }
  Widget  build(BuildContext context) {
    
    return  Container(
      
      decoration: const  BoxDecoration(gradient: LinearGradient(
         begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          //  stops: [0.1, 0.5, 0.7],
        colors: [ 

         Vx.amber300,
         Vx.green300,
         Vx.red300

      ])),
      child: SafeArea(
        child: Scaffold(
           
           body: Column(children: [
            Container(
               height: MediaQuery.of(context).size.height/2,
              
               
              decoration: const  BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20) ,bottomRight:Radius.circular(20)),
                // color: Colors.transparent,/
                image: DecorationImage(
                   fit: BoxFit.cover,
                   colorFilter: ColorFilter.mode(Vx.green300, BlendMode.saturation),
                  image: NetworkImage("https://wpcerber.com/media/2fa-wordpress-two-factor-authentication.png",))),
            ),
             Padding(
               padding: const EdgeInsets.all(20),
               child: InkWell(
                 onTap: (){
                   googlelogIn().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainHomePage(),)));
                   
                  
                 },
                 child: Container(
                   height: 80,
                   width: double.infinity,
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                    gradient: const  LinearGradient(colors: [
                    Vx.blue500,
                    Vx.green500,
                    Vx.yellow500,
                    Vx.red500
                    ])
                  ),
                  child: "Sign In with Google".text.bold.gray700.size(30).makeCentered(),
                 ),
               ),
             )
      
           ]),
        
        ),
      ),
    );
  }
}