// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YoutubeDisplay extends StatefulWidget {
//   final String url;
//   const YoutubeDisplay({super.key, required this.url});

//   @override
//   State<YoutubeDisplay> createState() => _YoutubeDisplayState();
// }

// class _YoutubeDisplayState extends State<YoutubeDisplay> {
//   YoutubePlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       print("YoutubeDisplay: ${widget.url}");
//       setState(() {
//         _controller = YoutubePlayerController(
//           initialVideoId: YoutubePlayer.convertUrlToId(
//               "https://youtu.be/x3GSMylTH8Q?si=peRlTsOmsyMcEaqJ")!,
//           flags: const YoutubePlayerFlags(
//             autoPlay: true,
//             mute: false,
//           ),
//         );
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       width: double.infinity,
//       child: _controller == null
//           ? const Center(child: CircularProgressIndicator())
//           : YoutubePlayerBuilder(
//               player: YoutubePlayer(controller: _controller!),
//               builder: (context, player) {
//                 return Column(
//                   children: [
//                     player,
//                   ],
//                 );
//               },
//             ),
//     );
//     // return const SizedBox();
//   }
// }
