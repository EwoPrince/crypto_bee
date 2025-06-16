
import 'package:crypto_beam/model/message_enum.dart';
import 'package:crypto_beam/x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case MessageEnum.text:
        return Text(
          widget.message,
        ).onDoubleTap(() {
          Clipboard.setData(ClipboardData(text: widget.message)).then((_) {
            showMessage(context, 'Copied to Clipboard');
          });
        });

      case MessageEnum.audio:
        return SizedBox();

      case MessageEnum.video:
        return SizedBox();

      case MessageEnum.flick:
        return SizedBox();

      case MessageEnum.gif:
      default:
        return SizedBox();
    }
  }
}

