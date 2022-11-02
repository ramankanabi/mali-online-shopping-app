import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CachedNetworkImage(
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/mali-online-shopping.appspot.com/o/p5.jpg?alt=media&token=491bd942-1ff1-4532-a0ef-0c7fdcc876a1",
          // progressIndicatorBuilder: (context, _, __) {
          //   return const CircularProgressIndicator();
          // },
          errorWidget: (context, _, error) {
            return Container(
              height: 80,
              width: 50,
              color: Colors.black,
            );
          },
          placeholder: (context, _) => Container(
            color: Colors.brown,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
