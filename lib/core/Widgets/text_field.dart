import '../constant.dart';
import 'package:flutter/material.dart';

class TextFieldItem extends StatelessWidget {
  final Function(String val) onValid;
  final VoidCallback onSeePassword;
  final bool isPassword;
  final bool isSecure;
  final String hint;
  final String head;
  final TextEditingController controller;
  final IconData icon;
  final Size size;
  const TextFieldItem({
    Key? key,
    required this.controller,
    required this.icon,
    required this.isPassword,
    required this.isSecure,
    required this.hint,
    required this.onValid,
    required this.size,
    required this.head,
    required this.onSeePassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.longestSide * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: TextStyle(
              color: Colors.white,
                fontSize: size.shortestSide * .05, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: size.longestSide * .01),
          TextFormField(
            validator: (valid) => onValid(valid!),
            controller: controller,
            obscureText: isPassword ? isSecure : false,
          style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ), enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: mainColor, width: 1),
              ),
              prefixIcon: Icon(icon,color: Colors.grey,),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: onSeePassword,
                      icon: Icon(
                        isSecure
                            ? Icons.visibility_off
                            : Icons.visibility_sharp,
                        color: isSecure ? Colors.grey : mainColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
