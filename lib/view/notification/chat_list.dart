import 'package:crypto_beam/model/message.dart';
import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/view/notification/chat_controller.dart';
import 'package:crypto_beam/view/notification/sender_message_card.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;

  const ChatList({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageController = ScrollController();
  DateTime? _lastSeparatorDate; // Keep track of the last separator date

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildDateSeparator(DateTime date, BuildContext context) {
    _lastSeparatorDate = date; // Update the last separator date
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Text(
        DateFormat.yMMMd().format(date), // Example date format
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildMessageCard(
    Message messageData,
    String uid,
    BuildContext context,
  ) {
    final datePublished = DateFormat.Hm().format(messageData.datePublished);

    return SenderMessageCard(
      message: messageData.text,
      date: datePublished,
      type: messageData.type,
      username: messageData.repliedTo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authProvider).user!.uid;
    _lastSeparatorDate =
        null; // Reset last separator date when rebuilding the list

    return StreamBuilder<List<Message>>(
      stream:
          ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        // Scroll to bottom on new messages
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _messageController
              .jumpTo(_messageController.position.maxScrollExtent);
        });

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyChatUI(context);
        }

        return ListView.separated(
          controller: _messageController,
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) {
            final currentMessageData = snapshot.data![index];
            final showSeparator = _lastSeparatorDate ==
                    null || // Show separator if it's the first message or...
                !DateUtils.isSameDay(
                    _lastSeparatorDate!,
                    currentMessageData
                        .datePublished); // ...if the date is different from the last separator

            if (showSeparator) {
              return _buildDateSeparator(
                  currentMessageData.datePublished, context);
            } else {
              return const SizedBox
                  .shrink(); // Otherwise, don't show a separator
            }
          },
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];

            // Set message seen status if not sender and not already seen
            if (!messageData.isSeen && messageData.senderId != uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    widget.recieverUserId,
                    messageData.messageId,
                  );
            }
            return _buildMessageCard(messageData, uid, context);
          },
        );
      },
    );
  }

  Widget _buildEmptyChatUI(BuildContext context) {
    return SizedBox.shrink();

    // Column(
    //   children: [
    //     FittedBox(
    //       child: Image.asset(
    //         'assets/meandpet.gif', // Consider a more themed empty chat asset
    //         fit: BoxFit.fill,
    //       ),
    //     ),
    //     Text(
    //       'Start a chat Stream', // Localize this string
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge
    //           ?.copyWith(fontWeight: FontWeight.w700),
    //     ),
    //   ],
    // );
  }
}
