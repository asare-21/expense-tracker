import 'dart:io';

import 'package:flutter/material.dart';

class InstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_outlined : Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text('Instructions'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Text('1.'),
            title: Text(
              'Open the menu and select New Track.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text('2.'),
            title: Text(
              'Fill in the pop up with the Title of the new track and the spending limit.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text('3.'),
            title: Text(
              'Longpress the tab generated below to add a new entry to the selected track.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text('4.'),
            title: Text(
              'Tap any tab to select and view expenses under it',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text('5.'),
            title: Text(
              'Swipe from the left to right to delete an expense entry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Text('6.'),
            title: Text(
              'Longpress on an expense track to delete it',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
