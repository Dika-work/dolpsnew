// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// import '../utils/loader/shimmer.dart';

// class CircularImage extends StatelessWidget {
//   const CircularImage(
//       {super.key,
//       this.fit,
//       required this.image,
//       this.isNetworkImage = true,
//       this.overlayColor,
//       this.widht = 56,
//       this.height = 56,
//       this.padding = 8.0});

//   final BoxFit? fit;
//   final String image;
//   final bool isNetworkImage;
//   final Color? overlayColor;
//   final double widht, height, padding;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widht,
//       height: height,
//       padding: EdgeInsets.all(padding),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(100)),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(100),
//         child: Center(
//           child: isNetworkImage
//               ? 
//               : InkWell(
//                   onTap: onTap,
//                   child: Image(
//                     image: AssetImage(image),
//                     fit: fit,
//                     color: overlayColor,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
