import 'package:flutter/cupertino.dart';
import 'package:tikeri/constants/config.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZimVideoCall extends StatefulWidget {
  final String callid;
  final String userid;

  const ZimVideoCall({super.key, required this.callid, required this.userid});
  @override
  State<ZimVideoCall> createState() => _ZimVideoCallState();
}

class _ZimVideoCallState extends State<ZimVideoCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        callID: widget.callid,
        userID: widget.userid,
        userName: "User : ${widget.userid}",
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()) ;
  }
}
