import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main()=>runApp(const MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState()=>_MyApp();
}

enum SingingCharacter { male, female }
class _MyApp extends State<MyApp> {
  var val = false;
  final _title = 'Lab1';
  var _lights = false;
  SingingCharacter _character = SingingCharacter.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.deepOrange,
          centerTitle: true
      ),
      body: PageView(children: [
        Container(
          padding:  EdgeInsets.all(25.0),
          child:Column(children: [
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.ac_unit,color: Colors.blueAccent,),
                hintText:"Введите ФИО",
                hintStyle: TextStyle(color: Colors.black,fontSize: 20),
                labelText: "ФИО",
                labelStyle: TextStyle(color: Colors.black,fontSize: 18),
              ),
            ),
            Padding(padding:  EdgeInsets.fromLTRB(20, 20, 0, 0),
              child:Row(children: [
                 Text("Я согласен со всеми условиями",style: TextStyle(fontSize: 17),),
                Checkbox(value: val, onChanged: (bool? value){
                  setState(() {
                    val=value!;
                  });
                })
              ],),),
            Column(children: [
              ListTile(
                title:  Text('Мужской'),
                leading: Radio(value: SingingCharacter.male,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value){
                      setState(() {
                        _character=value!;
                      });
                    }),
              ),
              ListTile(
                title:  Text('Женский'),
                leading: Radio(value: SingingCharacter.female,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value){
                      setState(() {
                        _character=value!;
                      });
                    }),
              )
            ],),
            Padding(padding:  EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: SwitchListTile(value: _lights,
                    title:  Text("Включить уведомления?"),
                    onChanged: (bool? val){
                      setState(() {
                        print(_lights=val!);
                      });
                    })
            ),
            Padding(padding:  EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: ElevatedButton(onPressed: (){print("Elevated Button");},
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                  fixedSize: Size(160, 50) ,
                ),
                child:  Text("Elevated Button",style: TextStyle(color: Colors.white),),),),
            Padding(padding:  EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: TextButton(onPressed: (){},
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    minimumSize: Size(160, 50) ,
                  ),
                  child:  Text("Text Button",style:TextStyle(color: Colors.white),)),)
          ],),
        ),
        Container(
          child:  Center(
            child: LinearProgressIndicator(),
          ))
      ],),
    );
  }
}

