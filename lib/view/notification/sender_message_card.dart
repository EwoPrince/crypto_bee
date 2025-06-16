import 'package:crypto_beam/model/message_enum.dart';
import 'package:crypto_beam/view/notification/display.dart';
import 'package:flutter/material.dart';


class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.username,
  }) : super(key: key);

  final String message;
  final String date;
  final MessageEnum type;
  final String username;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Padding(
                  padding: _getPaddingByType(type),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisplayTextImageGIF(
                        message: message,
                        type: type,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style:
                        textTheme.labelSmall?.copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  EdgeInsets _getPaddingByType(MessageEnum type) {
    return type == MessageEnum.text
        ? const EdgeInsets.only(left: 10, right: 30, top: 5, bottom: 20)
        : const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 25);
  }
}

