import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tikeri/screens/HomePage.dart';
import 'package:tikeri/screens/videosScreens/videos_screen.dart';
import 'package:video_player/video_player.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final TextEditingController _descriptionController = TextEditingController();
  final _picker = ImagePicker();
  late File? _videoFile;
  late VideoPlayerController? _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoPlayerReady = false;
  final _firebaseStorage = FirebaseStorage.instance;
  bool _isPlaying = false;
  bool _isVideoUploaded = false;

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _updateVideoFile(pickedFile.path);
    } else {
      _showSnackBar(context, 'No video selected.');
    }
  }

  Future<void> _recordVideo() async {
    final pickedFile = await _picker.getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _updateVideoFile(pickedFile.path);
    } else {
      _showSnackBar(context, 'No video recorded.');
    }
  }

  void _updateVideoFile(String filePath) {
    setState(() {
      _videoFile = File(filePath);
      _videoPlayerController = VideoPlayerController.file(_videoFile!);
      _initializeVideoPlayerFuture =
          _videoPlayerController!.initialize().then((_) {
            setState(() {
              _isVideoPlayerReady = true;
            });
          });
      _isPlaying = false; // Reset the play/pause button state
    });
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      try {
        final reference =
        _firebaseStorage.ref().child('videos/${DateTime.now()}.mp4');
        final UploadTask uploadTask = reference.putFile(_videoFile!);
        await uploadTask.whenComplete(() {
          setState(() {
            _isVideoUploaded = true;
          });
        });
        final TaskSnapshot downloadUrl = (await uploadTask);
        final String url = (await downloadUrl.ref.getDownloadURL());

        await FirebaseFirestore.instance.collection('videos').add({
          'publishedAt': DateTime.now(),
          'description': _descriptionController.text,
          'videoUrl': url,
        });

        _showSnackBar(context, 'Video uploaded successfully.');
      } catch (e) {
        print("Error uploading video: $e");
        _showSnackBar(context, 'Error uploading video: $e');
      } finally {
        setState(() {
          _isVideoUploaded = false;
        });
      }
    } else {
      _showSnackBar(context, 'No video selected.');
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isVideoUploaded = false;
    });
    _resetForm();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
        title: Text('Upload Video'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildVideoPlayer(),
              _buildActionButtons(),
              _buildDescriptionTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height*0.55, // Set your desired height
          width: double.infinity,
          child: _isVideoPlayerReady
              ? _isVideoUploaded
              ? Center(child: CircularProgressIndicator())
              : VideoPlayer(_videoPlayerController!)
              : Center(
            child: Text(
              'Select a video to preview',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            onPressed: () {
              setState(() {
                _isPlaying = false;
                _isVideoPlayerReady = false;
                _videoPlayerController?.pause();
                _videoPlayerController?.seekTo(Duration.zero);
                _videoFile = null;
                _videoPlayerController = null;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: _pickVideo,
                icon: const Icon(Icons.video_library),
              ),
              Text('Select video')
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: _recordVideo,
                icon: const Icon(Icons.videocam),
              ),
              Text('Record')
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  if (_isPlaying) {
                    _videoPlayerController?.pause();
                  } else {
                    _videoPlayerController?.play();
                  }
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
              Text('Preview')
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: _uploadVideo,
                icon: const Icon(Icons.cloud_upload),
              ),
              Text('Upload')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          hintText: 'Description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: 5,
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
        onSaved: (value) {
          _descriptionController.text = value!;
        },
      ),
    );
  }

  void _resetForm() {
    _descriptionController.text = '';
    setState(() {
      _videoFile = null;
    });
  }
}
