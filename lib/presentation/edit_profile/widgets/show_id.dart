import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/constant.dart';

class ShowIdItem extends StatelessWidget {
  final String id; 
  final Size size;
  const ShowIdItem({Key? key, required this.id,  required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    contentPadding: const EdgeInsets.all(10),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Your ID",
                          style: TextStyle(
                              fontSize: size.shortestSide * .055,
                              fontWeight: FontWeight.w600,
                              color: mainColor),
                        ),
                        SizedBox(
                          height: size.height * .01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                              id,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.shortestSide * .05,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  FlutterClipboard.copy(id)
                                      .whenComplete(() {
                                    Fluttertoast.showToast(
                                        msg: "Id Copy Successfully");
                                  });
                                },
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                      ],
                    ),
                  ));
        },
        title: const Text("Get Your Id"),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
