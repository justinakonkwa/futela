import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: AppText(
            text: 'Home page',
          ),
        ),
      ),
    );
  }
}
