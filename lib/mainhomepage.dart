import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/services/Authentication.dart';
import 'package:todo/services/sql_helper.dart';
import 'package:velocity_x/velocity_x.dart';
 class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
   List<Map<String ,dynamic>>_journals=[];
   bool _isloading =true;
    void _refreshjournals()async{

      final data = await SQLHelper.getItems();
      setState(() {
        _journals=data;
        _isloading=false;
      });
    }
  @override
   void initState() {
    // TODO: implement initState
    super.initState();
     _refreshjournals();
      print("..number of items ${_journals.length}");
  }
   final TextEditingController _titlecontrolar=TextEditingController();
    final TextEditingController _descriptioncontrolar=TextEditingController();
    Future<void>  _addItem()async{
       await SQLHelper.createItem(_titlecontrolar.text, _descriptioncontrolar.text);
       _refreshjournals();
        print("..number of items ${_journals.length}");

    }
     Future<void>  _updateItem(int id)async{
      await SQLHelper.updatedItem(id,
      _titlecontrolar.text, _descriptioncontrolar.text);
      _refreshjournals();
     }
     void _deleteItem(int id)async{
      await SQLHelper.deleteItem(id);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sucessfully Deleted a item")));
        _refreshjournals();
     }

   void _showForm (int ?id,)async{
     if(id !=null){
      final ExistingJournal=_journals.firstWhere((element) => element['id']==id);
      _titlecontrolar.text=ExistingJournal['title'];
      _descriptioncontrolar.text=ExistingJournal['description'];
     }
      showModalBottomSheet(
         backgroundColor: Vx.orange200,
         isScrollControlled: true,
         context: context, builder:(_)=>Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom +20,



        ),

         child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment:CrossAxisAlignment.end,
          children: [
             "ADD TODO".text.bold.size(30).rose600.makeCentered().p(16),
             TextField(
              controller: _titlecontrolar, 
               decoration:  const InputDecoration(
                 border: OutlineInputBorder(),
                hintText: 'title'),

             ),
             const   SizedBox(height: 10,),
               TextField(
              controller: _descriptioncontrolar, 
               decoration: const  InputDecoration(
                 border: OutlineInputBorder(),
                hintText: 'Description'),

             ),
              const  SizedBox(height: 20,),

              ElevatedButton(
                 
                onPressed: ()async{
                 if(id==null){
                  await _addItem(); 
                 }
                  if(id!=null){
                    await _updateItem(id);
                  }
                  //clear text field;
                   _titlecontrolar.text='';
                   _descriptioncontrolar.text='';
                   //close the bottom   sheet
                     Navigator.of(context).pop();

              },  child: Text(id==null? 'Create New':'update')
              ),

          
         ]),

      ));
     

   }
    void SignOut()async{
      await GoogleSignIn().disconnect();
             FirebaseAuth.instance.signOut();

    }

  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Vx.teal400,
       appBar: AppBar(title: "Todo App".text.gray500.bold.make(),
        actions: [
           
          IconButton(onPressed: () async{
              
             SignOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GSignIn()));
            

          }, icon: Icon(Icons.logout_outlined,color: Colors.black87,))
          ],
       flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Vx.green200,Vx.yellow300]),
      ),),
        
        centerTitle: true,),
        floatingActionButton: FloatingActionButton
        (
           backgroundColor: Vx.amber300,
          onPressed: ()=>_showForm(null),
         child:  Icon(Icons.add),
        ),
        body: ListView.builder(
           

           itemCount: _journals.length,
          itemBuilder: (context,index)=>Card(
             
            elevation: 6,
          //  color: Vx.orange400,
           margin: EdgeInsets.all(15),
           child: Container(
             decoration: BoxDecoration(
               
              gradient: LinearGradient(
               tileMode: TileMode.decal,
               transform: GradientRotation(15),
              colors: [
               Vx.orange200,
               Vx.white,
                Vx.green200


             ])),
             child: ListTile(
              title: Text(_journals[index]['title']),
               subtitle: Text(_journals[index]['description']),
                trailing: SizedBox(
                  width: 100,
                  child: 
                Row(
                  children: [
                    IconButton(onPressed: ()=>_showForm(_journals[index]['id']), icon: Icon(Icons.edit,)),
                    IconButton(onPressed: ()=>_deleteItem(_journals[index]['id']), icon: Icon(Icons.delete ,color: Vx.red500,))
           
                  ],
                )),
             ),
           ),
        ))
    );
  }
}