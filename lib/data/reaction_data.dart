import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final imgs = [
  'assets/image/happy.png',
  'assets/image/angry.png',
  'assets/image/in-love.png',
  'assets/image/sad.png',
  'assets/image/surprised.png',
  'assets/image/mad.png',
];
final reactions = [
  Reaction<String>(
    value: '0',
    title: _buildTitle('Happy'),
    previewIcon: _buildReactionsPreviewIcon('assets/image/happy.png'),
    icon: _buildReactionsIcon(
      'assets/image/happy.png',
      const Text(
        'Happy',
        style: TextStyle(
          color: Color(0XFF3b5998),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '1',
    title: _buildTitle('Angry'),
    previewIcon: _buildReactionsPreviewIcon('assets/image/angry.png'),
    icon: _buildReactionsIcon(
      'assets/image/angry.png',
      const Text(
        'Angry',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '2',
    title: _buildTitle('In love'),
    previewIcon: _buildReactionsPreviewIcon('assets/image/in-love.png'),
    icon: _buildReactionsIcon(
      'assets/image/in-love.png',
      const Text(
        'In love',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '3',
    title: _buildTitle('Sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/image/sad.png'),
    icon: _buildReactionsIcon(
      'assets/image/sad.png',
      const Text(
        'Sad',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '4',
    title: _buildTitle('Surprised'),
    previewIcon: _buildReactionsPreviewIcon('assets/image/surprised.png'),
    icon: _buildReactionsIcon(
      'assets/image/surprised.png',
      const Text(
        'Surprised',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '5',
    title: _buildTitle('Mad'),
    previewIcon: _buildReactionsPreviewIcon('assets/image/mad.png'),
    icon: _buildReactionsIcon(
      'assets/image/mad.png',
      const Text(
        'Mad',
        style: TextStyle(
          color: Color(0XFFf05766),
        ),
      ),
    ),
  ),
];

Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Container _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}
