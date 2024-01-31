import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late RtcEngine _engine;
  late User _currentUser;
  late String _channelName = "default_channel";

  @override
  void initState() {
    super.initState();
    _initAgora();
    _getCurrentUser();
  }

  // Initialize Agora RTC Engine
  Future<void> _initAgora() async {
    await [Permission.camera, Permission.microphone].request();
    _engine = await RtcEngine.create("e444e6ec14e14f65a89d08afca60be9d"); // Replace with your Agora App ID
    await _engine.enableVideo();
    await _engine.enableAudio();

  }

  // Get the current user details
  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser!;
  }

  // Start a video call
  void _startVideoCall(String receiverUid) {
    _firestore.collection('calls').add({
      'callerUid': _currentUser.uid,
      'receiverUid': receiverUid,
      'channelName': _channelName,
      'callType': 'video',
      'status': 'initiated',
    });
  }

  // Start a voice call
  void _startVoiceCall(String receiverUid) {
    _firestore.collection('calls').add({
      'callerUid': _currentUser.uid,
      'receiverUid': receiverUid,
      'channelName': _channelName,
      'callType': 'voice',
      'status': 'initiated',
    });
  }

  void _showLargerImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 250.0,
            height: 250.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 200.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigate to the video call screen
  void _navigateToVideoCall(String channelName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(channelName: channelName),
      ),
    );
  }

  @override
  void dispose() {
    _engine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Calls App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _firestore
                .collection('calls')
                .where('receiverUid', isEqualTo: _currentUser.uid)
                .where('status', isEqualTo: 'initiated')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }

              var calls = snapshot.data?.docs;

              if (calls!.isEmpty) {
                return SizedBox.shrink();
              }

              var call = calls[0];
              var callerUid = call['callerUid'];
              var channelName = call['channelName'];

              return AlertDialog(
                title: Text('Incoming Call'),
                content: Text('Caller: $callerUid'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Answer the call
                      _firestore.collection('calls').doc(call.id).update({'status': 'accepted'});
                      _navigateToVideoCall(channelName);
                    },
                    child: Text('Accept'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Reject the call
                      _firestore.collection('calls').doc(call.id).update({'status': 'rejected'});
                    },
                    child: Text('Reject'),
                  ),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var users = snapshot.data?.docs;
              List<Widget> userList = [];

              for (var user in users!) {
                var userData = user.data();
                var uid = user.id;

                // Exclude the current user from the list
                if (_currentUser.uid != uid) {
                  userList.add(
                    ListTile(
                      leading: InkWell(
                        onTap: () {
                          _showLargerImageDialog(userData['imageurl']);
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData['imageurl'] ?? ''),
                        ),
                      ),
                      title: Text(userData['username']),
                      subtitle: Text(userData['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.videocam),
                            onPressed: () {
                              _startVideoCall(uid);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () {
                              _startVoiceCall(uid);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }

              return Expanded(
                child: ListView(
                  children: userList,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class VideoCallScreen extends StatelessWidget {
  final String channelName;

  const VideoCallScreen({Key? key, required this.channelName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Center(
        child: Text('Joining Video Call on Channel: $channelName'),
      ),
    );
  }
}
