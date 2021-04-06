import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String selectedItem;
  final String name;
  final IconData icon;

  NavBarItem({this.selectedItem, this.name, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: selectedItem == name ? Colors.white : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(
          selectedItem == name ? 50 : 0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(selectedItem == name ? 8.0 : 0),
        child: Icon(
          icon,
          color: Colors.white,
          size: selectedItem == name ? 20.0 : 30,
        ),
      ),
    );
  }
}