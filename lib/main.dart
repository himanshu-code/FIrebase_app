import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}
class MyApp extends StatefulWidget{
  @override
  
  _MyAppState createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var fsconnect = FirebaseFirestore.instance;

  myget() async {
    var d = await fsconnect.collection("commands").get();
    // print(d.docs[0].data());

    for (var i in d.docs) {
      print(i.data());
    }
  }
  var webData;
  web(cmd,image_name) async{
  
  var url="http://192.168.43.142/cgi-bin/web.py?x=${cmd}&y=${image_name}";
  var response= await http.get(url);
  print(response.body);
  setState(() {
   webData=response.body;
  });
  fsconnect.collection("commands").add({
                                        'command': cmd,
                                        'image name': image_name,
                                        'output': webData,
                                          });
   
} 



  @override
  Widget build(BuildContext context) {
    
 String cmd;
  String image_name;
  var User_icon=Icon(Icons.person,color: Colors.blue,);
  var Home_icon=Icon(Icons.home, color:Colors.blue);

  var User_button=IconButton(icon: User_icon, onPressed: null);
  var Home_button=IconButton(icon: Home_icon, onPressed: null);
   var url="https://cdn.pixabay.com/photo/2012/04/26/19/47/penguin-42936_960_720.png";
   var linux_image=NetworkImage(url);
   var url2="https://www.jpaul.me/wp-content/uploads/2020/04/Moby-logo.png?w=640";
   var logo=Image.network(url2);
   var box=Container(height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.teal,image: DecorationImage(image: linux_image,fit: BoxFit.fitWidth),),
                    child: ListView (padding: const EdgeInsets.all(10),
                    
                    children: <Widget>[Container(alignment: Alignment.center,
                                                  margin: EdgeInsets.all(10), 
                                                  width: 350,
                                                  
                                                  color:Colors.transparent,
                                                  child: TextField(onChanged: (value) { cmd=value;
                                                  
                                                  },
                                                    autocorrect: false,
                                                  textAlign: TextAlign.left,
                                                  cursorColor: Colors.purple,
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    border: OutlineInputBorder(),
                                                    hintText: "Enter Linux Command",
                                                    prefixIcon: Icon(Icons.send,color: Colors.purple,),
                                                  ),
                                                  ),
                                                ),
                                      Container(alignment: Alignment.center,
                                                  margin: EdgeInsets.all(10),
                                                  width: 350,
                                                  color:Colors.transparent,
                                                  child: TextField( onChanged: (value) { image_name=value;},
                                                    autocorrect: false,
                                                  textAlign: TextAlign.left,
                                                  cursorColor: Colors.purple,
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    border: OutlineInputBorder(),
                                                    hintText: "Enter Image Name",
                                                    prefixIcon: Icon(Icons.send,color: Colors.purple,),
                                                  ),
                                                  ),
                                                ),
                                                RaisedButton(
                                                  color: Colors.black,
                                                textColor: Colors.teal,
                                                disabledColor: Colors.grey,
                                                disabledTextColor: Colors.black,
                                                padding: EdgeInsets.all(10),
                                                
                                                splashColor: Colors.redAccent,
                                                  onPressed: () { 
                                                   web(cmd,image_name);
                                                  
                                                    },
                                                 child: Text("Run commands and add to Firebase")),
                                                 Container(width:300,
                                                 alignment: Alignment.bottomCenter,
                                                 height: 200,
                                                 margin: EdgeInsets.all(20),
                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.transparent),                                                
                                                 child: Text(webData ??" Output",style: TextStyle(color:Colors.purpleAccent),),
                                                 )
                                                 
                                      ],
                                ),
                    
                    );

  var appbar=AppBar(leading: logo,title: Text('My Firebase App',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.normal,color: Colors.blue),),
  actions: <Widget>[User_button,Home_button],
  backgroundColor: Colors.black,
  );
  var myhome=Scaffold(appBar: appbar,
    body: box,
  );
    return myhome;
  }
}

