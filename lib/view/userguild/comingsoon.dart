import 'package:crypto_bee/widgets/button.dart';
import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Under Construction"),
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.yellow.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage('assets/comingsoon.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            button(context, 'See you soon', () {}),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
