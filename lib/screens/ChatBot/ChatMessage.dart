import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender, required this.isImage}) : super(key: key);
  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: sender == "user" ? Colors.blue : Colors.blue, // Utilisation correcte de Colors
          child: Text(sender[0].toUpperCase(),selectionColor: Colors.white,),
        ).p8(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sender, style: TextStyle(fontWeight: FontWeight.bold)),
              isImage
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        text,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : Text(text),
            ],
          ).p8(),
        ),
      ],
    ).py8();
  }
}
