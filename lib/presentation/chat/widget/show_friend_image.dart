import 'package:flutter/material.dart'; 

class ShowFrindImage extends StatefulWidget {
  final String friendId;
  final String friendImg;
  const ShowFrindImage(
      {Key? key, required this.friendId, required this.friendImg})
      : super(key: key);

  @override
  State<ShowFrindImage> createState() => _ShowFrindImageState();
}

class _ShowFrindImageState extends State<ShowFrindImage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: InteractiveViewer(
              maxScale: 17,
              child: Center(
                child: Image.network(widget.friendImg),
              )),
        ),
      ),
    );
  }
}
