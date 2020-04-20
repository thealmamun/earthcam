//
//import 'package:chewie/chewie.dart';
//import 'package:chewie/src/chewie_player.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:video_player/video_player.dart';
//
//
//
//class ServerVideoPlayer extends StatefulWidget {
//
//
//  @override
//  State<StatefulWidget> createState() {
//    return _ServerVideoPlayerState();
//  }
//}
//
//class _ServerVideoPlayerState extends State<ServerVideoPlayer> {
//  VideoPlayerController _videoPlayerController1;
//  VideoPlayerController _videoPlayerController2;
//  ChewieController _chewieController;
//
//  @override
//  void initState() {
//    super.initState();
//    _videoPlayerController1 = VideoPlayerController.network(
//        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
//    _videoPlayerController2 = VideoPlayerController.network(
//        'https://www.radiantmediaplayer.com/media/bbb-360p.mp4');
//    _chewieController = ChewieController(
//      videoPlayerController: _videoPlayerController2,
//      aspectRatio: 3 / 2,
//      autoPlay: true,
//      looping: true,
//      fullScreenByDefault: true,
//      showControls: false,
////      autoInitialize: true,
//    );
//  }
//
//  @override
//  void dispose() {
//    _videoPlayerController1.dispose();
//    _videoPlayerController2.dispose();
//    _chewieController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//   return Scaffold(
//     body: Column(
//       children: <Widget>[
//         Expanded(
//           child: Center(
//             child: Chewie(
//               controller: _chewieController,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
//  }
//}