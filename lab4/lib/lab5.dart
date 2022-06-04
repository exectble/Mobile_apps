import 'package:flutter/material.dart';
import 'main.dart';

class FriendsList extends StatefulWidget {
  final String accessToken;
  final String userId;
  final String userImageUrl;
  final List<dynamic> friendsList;
  final numOfFriends;
  final String userFirstname;
  final String userLastname;

  const FriendsList({ Key? key, required this.accessToken, required this.userId, required this.userImageUrl, this.numOfFriends, required this.friendsList, required this.userFirstname, required this.userLastname}) : super(key: key);

  @override
  createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userFirstname} ${widget.userLastname}, друзья: ${widget.numOfFriends}", style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.black,
        leading: Image.network(
            widget.userImageUrl),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: widget.numOfFriends,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: (){
              setState(() {
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network("${widget.friendsList[index]["photo_50"]}"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("${widget.friendsList[index]["first_name"]} ${widget.friendsList[index]["last_name"]}", style: const TextStyle(color: Colors.lightBlue, fontSize: 14)),
                ),
                Icon(widget.friendsList[index]["online_mobile"] == 1 ? Icons.phone_android : Icons.circle,
                  color: widget.friendsList[index]["online"] == 1 ? Colors.green : Colors.grey,
                  size: widget.friendsList[index]["online_mobile"] == 1 ? 15.0 : 10.0,)
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
          thickness: 3,
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Запросы по REST API (lab5)  ", style: TextStyle(color: Colors.white)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Вернуться',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Icon(Icons.arrow_back, size: 20.0,),
                ],
              ),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.lightBlue)),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        color: Colors.black,
      ),
      backgroundColor: const Color.fromARGB(255, 45, 45, 45),
      
    );
  }
}

