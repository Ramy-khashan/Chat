import 'package:flutter/material.dart';

import '../../../core/constant.dart';

class AddFriendById extends StatelessWidget {
  final TextEditingController controller;
  final Size size;
  final Function() onTap;
  const AddFriendById(
      {Key? key,
      required this.controller,
      required this.onTap,
      required this.size})
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
                backgroundColor: Colors.transparent,
                    contentPadding:  EdgeInsets.zero,
                    content: Container(
                      padding:const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Add Your Frind",
                            style: TextStyle(
                                fontSize: size.shortestSide * .05,
                                fontWeight: FontWeight.w600,
                                color: mainColor),
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Frind Id",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: mainColor, width: 1),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: onTap, child: const Text("Confirm")),
                              TextButton(
                                  onPressed: () {
                                    controller.clear(); 
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
        },
        title: const Text("Add Friend By Id"),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
