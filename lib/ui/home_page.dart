
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  // ignore: deprecated_member_use
  List<Contact> contacts = List();

  @override
  // ignore: must_call_super
  void initState() {

   _getAllContacts();

  }

  // codigo para testar o bd
  /*
  @override
  void initState() {
    super.initState();

    Contact c = Contact();
    c.nome = "rosa";
    c.email ="rosa2051@gmail.com";
    c.phone = "332591";
    c.img = "imgtest";

    helper.saveContact(c);

   helper.getAllContacts().then((list) {
      print(list);
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length ,
        itemBuilder:(context, index){
          return _contactsCard(context, index);
        }
      ),
    );
  }

  Widget _contactsCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children:<Widget> [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ? 
                    FileImage(File(contacts[index].img)) :
                        AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                  padding:EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    Text(contacts[index].nome ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold)
                      ),
                    Text(contacts[index].email ?? "",
                    style: TextStyle(
                        fontSize: 18.0),
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(
                          fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOpitions(context,index);
        //_showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showOpitions(BuildContext context,int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){

            },
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  //ocupar o menor espaço possivel
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [

                   Padding(padding: EdgeInsets.all(10.0),
                   // ignore: deprecated_member_use
                   child:  FlatButton(
                     child: Text("ligar",
                       style: TextStyle(
                           color: Colors.red,fontSize: 20.0),
                     ),
                     onPressed: (){
                       Navigator.pop(context);
                       launch("tel:${contacts[index].phone}");
                     },
                   ),
              ),
                  Padding(padding: EdgeInsets.all(10.0),
                    // ignore: deprecated_member_use
                  child: FlatButton(
                       child: Text("Editar",
                         style: TextStyle(
                             color: Colors.red,fontSize: 20.0),

                       ),
                       onPressed: (){
                         Navigator.pop(context);
                         _showContactPage(contact: contacts[index]);
                       },
                     ),
              ),

                    Padding(padding: EdgeInsets.all(10.0),
                      // ignore: deprecated_member_use
                      child:  FlatButton(
                       child: Text("Excluir",
                         style: TextStyle(
                             color: Colors.red,fontSize: 20.0),
                       ),
                       onPressed: (){
                         helper.deleteContact(contacts[index].id);
                         setState(() {
                           contacts.removeAt(index);
                           Navigator.pop(context);
                         });
                       },
                     ),
                   ),
                  ],

                ),

              );
            },
          );
        }
    );
  }
  
   void _showContactPage({Contact contact}) async{
   final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(
          contact: contact,
        ))
    );
   if(recContact != null){
     if(contact != null){
       await helper.UpdateContact(recContact);
     }else{
       await helper.saveContact(recContact);
     }
      _getAllContacts();
   }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

}
