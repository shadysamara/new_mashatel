import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/messanger/models/message_model.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MassengerPage extends StatelessWidget {
  String chatId;
  String otherId;
  AppGet appGet = Get.find();

  MassengerPage(this.otherId, {this.chatId});
  TextEditingController textEditingController = TextEditingController();
  ScrollController _controller = ScrollController();
  ///////////////////////////////////////////////////////////////////
  Widget buildMessage({Message messageData, String myId, context}) {
    if (messageData.senderId == myId) {
      return myMessageView(messageData, context);
    } else {
      return partnerMessageView(messageData, context);
    }
  }

///////////////////////////////////////////////////////////////
  Widget myMessageView(Message messageData, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(messageData.hour),
          ),
          Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: _myMessageContentWidget(messageData, context)),
        ],
      ),
    );
  }

  Widget partnerMessageView(Message messageData, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: remoteMessageView(messageData, context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(messageData.hour),
          ),
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////
  Widget _myMessageContentWidget(Message messageData, context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Directionality.of(context) == TextDirection.ltr
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      children: <Widget>[
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: -8,
          bottom: 0,
          child: Image.asset(
            Directionality.of(context) == TextDirection.ltr
                ? 'assets/images/chat_arrow_right.png'
                : 'assets/images/chat_arrow_left.png',
            color: AppColors.primaryColor,
            height: 12,
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 50.w,
            maxWidth: 200.h,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.w))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 6, bottom: 6, right: 4, left: 4),
                child: Text(
                  messageData.text,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

////////////////////////////////////////////////////////////////
  Widget _partnerContentWidget(Message messageData, context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 50.w,
        maxWidth: 200.h,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8.w))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 6, bottom: 6, right: 4, left: 4),
            child: Text(
              messageData.text,
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////
  Widget remoteMessageView(Message messageData, context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12.0),
              child: _remoteMessageContentWidget(messageData, context)),
        ),
      ],
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Widget _remoteMessageContentWidget(Message messageData, context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Directionality.of(context) == TextDirection.ltr
          ? Alignment.bottomLeft
          : Alignment.bottomRight,
      children: <Widget>[
        Positioned.directional(
          textDirection: Directionality.of(context),
          start: -8,
          bottom: 0,
          child: Image.asset(
            Directionality.of(context) == TextDirection.ltr
                ? 'assets/images/chat_arrow_left.png'
                : 'assets/images/chat_arrow_right.png',
            color: AppColors.secondaryElement,
            height: 12,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 200,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.secondaryElement,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(
                  alignment: Alignment.center,
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 6, bottom: 6, right: 4, left: 4),
                      child: Text(
                        messageData.text ?? Text('deletedMessage'),
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BaseAppbar('messenger'),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    MashatelClient.mashatelClient.getAllChatMessages(chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: FlareActor(
                        "assets/animations/loading.flr",
                        sizeFromArtboard: true,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        animation: "loading",
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data == null) {
                    return Center(
                      child: Text('No Messages'),
                    );
                  } else {
                    List<Message> messages = snapshot.data.docs
                        .map((e) => Message.frmMap(e.data()))
                        .toList();

                    return ListView.builder(
                      controller: _controller,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Timer(
                            Duration(milliseconds: 300),
                            () => _controller
                                .jumpTo(_controller.position.maxScrollExtent));
                        return buildMessage(
                            context: context,
                            messageData: messages[index],
                            myId: MashatelClient.mashatelClient.getUser());
                      },
                    );
                  }
                },
              ),
            )),
            Container(
              color: AppColors.greyBackground,
              height: 60.h,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    onTap: () {
                      Timer(
                          Duration(milliseconds: 300),
                          () => _controller
                              .jumpTo(_controller.position.maxScrollExtent));
                    },
                    controller: textEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: translator.translate('messenger_label')),
                  )),
                  GestureDetector(
                    onTap: () {
                      if (textEditingController.text.trim().isNotEmpty) {
                        DateTime dateTime = DateTime.now();
                        Message message = Message(
                            text: textEditingController.text,
                            hour: '${dateTime.hour}:${dateTime.minute}',
                            date:
                                '${dateTime.year}-${dateTime.month}-${dateTime.day}',
                            senderId: MashatelClient.mashatelClient.getUser(),
                            recieverId: this.otherId,
                            timestamp: FieldValue.serverTimestamp());

                        MashatelClient.mashatelClient
                            .newMessage(chatId: chatId, message: message);
                        textEditingController.clear();
                        Timer(
                            Duration(milliseconds: 300),
                            () => _controller
                                .jumpTo(_controller.position.maxScrollExtent));
                      }
                    },
                    child: Container(
                      height: 60.h,
                      width: 60.h,
                      color: AppColors.primaryColor,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
