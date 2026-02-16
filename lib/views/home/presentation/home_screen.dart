import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(text: '< March 2026 > '),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Ionicons.star_outline)),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [
            
          ],
        )),
      ),
    );
  }
}
