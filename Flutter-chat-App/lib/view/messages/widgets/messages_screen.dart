import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/service_locator.dart';
import 'package:chat/utils/failure.dart';
import 'package:chat/view/messages/bloc/messages_bloc.dart';
import 'package:chat/view/messages/widgets/messages_header.dart';
import 'package:chat/view/utils/constants.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/footer.dart';
import 'package:chat/view/messages/widgets/messages_list.dart';
import 'package:chat/view/widgets/progress_indicator.dart';
import 'package:chat/view/widgets/try_again_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:bubble/bubble.dart';
import 'package:video_player/video_player.dart';
import '../../../service_locator.dart';

class MessagesScreen extends StatefulWidget {
  final User friend;
  MessagesScreen({@required this.friend});
  static String routeID = "MESSAGE_SCREEN";

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessagesScreen> {
  Future<List<Message>> messagesFuture;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  TextEditingController controller;
  DeviceData deviceData;
  bool showMessages = false;

  final FlutterTts flutterTts=FlutterTts();

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  MessagesBloc messagesBloc;
  @override
  void initState() {
    messagesBloc = serviceLocator<MessagesBloc>();
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messagesBloc.close();
    controller.dispose();
    super.dispose();
  }

  void response(query) async {
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": "hi there"
      });
    });
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage("en-Us");
    await flutterTts.speak("hi there");
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
    deviceData = DeviceData.init(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: kBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MessagesHeader(friend: widget.friend),
              Expanded(
                child:  Column(
                    children: <Widget>[
                      const WhiteFooter(),
                      Flexible(
                          child: ListView.builder(
                              reverse: true,
                              itemCount: messsages.length,
                              itemBuilder: (context, index) => chat(
                                  messsages[index]["message"].toString(),
                                  messsages[index]["data"]))),
                      Divider(
                        height: 5.0,
                        color: Colors.deepOrange,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                                child: TextField(
                                  controller: messageInsert,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Send your message",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                                )),
                            Container(
                              padding: EdgeInsets.only(
                                  top: deviceData.screenHeight * 0.01,
                                  bottom: deviceData.screenHeight * 0.01,
                                  right: deviceData.screenWidth * 0.02),
                              child: IconButton(

                                  icon: Icon(
                                    Icons.send,
                                    color: kBackgroundButtonColor,
                                    size: deviceData.screenWidth * 0.065,
                                  ),
                                  onPressed: () {
                                    if (messageInsert.text.isEmpty) {
                                      print("empty message");
                                    } else {
                                      setState(() {
                                        messsages.insert(0,
                                            {"data": 1, "message": messageInsert.text});
                                      });
                                      response(messageInsert.text);
                                      messageInsert.clear();
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.deepOrange : Colors.orangeAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(
                      data == 0 ? "assets/bot.png" : "assets/user.png"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          )),
    );
  }
}