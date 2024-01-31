import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/theme.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({Key? key}) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late QuerySnapshot querySnapshot;
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  int _currentVideoIndex = 0;
  String? desc ;
  String? uid;

  bool _isFollowing = false;
  bool _isLoading = true;
  var userData = {};
  String currentUser = FirebaseAuth.instance.currentUser!.uid;

  getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .get();
      userData = userSnap.data()!;
      //print(userData);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  getIsFollowing() async {
    setState(() {
      _isLoading = true;
    });
    try {
      //List userFollowing = widget.userSnap['following'];
      _isFollowing = userData['following'].contains(uid);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchVideo(int index) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .get();
    final data = snapshot.docs[index % snapshot.docs.length].data();
    setState(() {
      querySnapshot = snapshot;
      _controller = VideoPlayerController.network(data['videoUrl'])
        ..initialize().then((_) {
          _controller.play();
          setState(() {
            _isPlaying = true;
          });
        });
    });
    desc = data['description'];
    uid = data['uid'];
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('');
    _fetchVideo(_currentVideoIndex);
    getUserData();
    getIsFollowing();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggleVideoPlayback() {
    print("flow");
    if (_controller != null) {
      print("not empty");
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.up,
        onDismissed: (_) {
          setState(() {
            _currentVideoIndex++;
          });
          _fetchVideo(_currentVideoIndex);
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              if (_controller.value.isInitialized)
                FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )
              else
                Center(child: CircularProgressIndicator()), // Placeholder while the video loads
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(0.1)
                    ],
                    stops: [0.0, 0.69],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // User Info Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://avatars3.githubusercontent.com/u/52818067?s=400&u=4347e9d0856b8e884693dc6d7762ae4e1eefd38a&v=4')),
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  // Name & Username
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Yash Joshi",
                                        style:
                                        MyTheme().textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFE3E5E7),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Text(
                                        "@username",
                                        style:
                                        MyTheme().textTheme.bodyText2?.copyWith(
                                          color: Color(0xFFA6ACB2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),

                                ],
                              ),
                             ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "$desc",
                            style: MyTheme().textTheme.bodyText2?.copyWith(
                              color: Color(0xFFE3E5E7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(
                            height: 4,
                          ),
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: _toggleVideoPlayback,
                                  child: Container(
                                    // Adjust the size and padding based on your requirements
                                    width: 50,
                                    height: 50,
                                    child: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: 32,
                    margin: EdgeInsets.only(
                        right: 16, top: MediaQuery.of(context).size.height / 1.68),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(100, 26, 26, 26),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset(
                                "assets/icons/Icon=HeartOutline.svg",
                                width: 20,
                                height: 20,
                                color: const Color(0xFFA6ACB2),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(100, 26, 26, 26),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset(
                                "assets/icons/Icon=ShareOutline.svg",
                                width: 20,
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
