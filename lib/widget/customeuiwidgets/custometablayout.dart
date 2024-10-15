import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custometablayout extends StatefulWidget {
  const Custometablayout({super.key});

  @override
  State<Custometablayout> createState() => _CustometablayoutState();
}

class _CustometablayoutState extends State<Custometablayout> {

  int _selectedIndex = 0;  // Keeps track of the selected tab

  final List<String> _tabs = ['ULD', 'Trolley'];  // Tabs text
  final List<Widget> _tabContents = [  // Tabs content
    Center(child: Text('ULD Content')),
    Center(child: Text('Trolley Content')),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == index
                        ? Colors.blue
                        : Colors.transparent,
                    width: 3.0,
                  ),
                ),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedIndex == index
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
