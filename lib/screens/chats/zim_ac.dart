import 'package:flutter/cupertino.dart';
import 'package:tikeri/constants/config.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZimAudioCall extends StatefulWidget {
  final String callid;
  final String userid;

  const ZimAudioCall({super.key, required this.callid, required this.userid});
  @override
  State<ZimAudioCall> createState() => _ZimAudioCallState();
}

class _ZimAudioCallState extends State<ZimAudioCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        callID: widget.callid,
        userID: widget.userid,
        userName: "User : ${widget.userid}",
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()) ;
  }
}
