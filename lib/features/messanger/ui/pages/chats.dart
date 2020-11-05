import 'package:flutter/material.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/messanger/ui/pages/massenger.dart';
import 'package:mashatel/widgets/custom_appbar.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
        ),
        body: AllExistsChats(MashatelClient.mashatelClient.getUser()));
  }
}

class AllExistsChats extends StatelessWidget {
  String myId;
  AllExistsChats(this.myId);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: FutureBuilder<List<Map>>(
        future: MashatelClient.mashatelClient.getAllChats(myId),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData && snapshot.data == null) {
            return Center(
              child: Text('No Chats Found'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Map<dynamic, dynamic>> data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                String allUsers = data[index]['otherUserMap']['isMarket']
                    ? '${data[index]['otherUserMap']['userName']},${data[index]['otherUserMap']['companyName']}'
                    : '${data[index]['otherUserMap']['userName']}';

                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MassengerPage(
                            chatId: data[index]['chatId'],
                          );
                        },
                      ));
                    },
                    title: Text(allUsers),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
