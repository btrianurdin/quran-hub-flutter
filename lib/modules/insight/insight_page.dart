import 'package:flutter/material.dart';
import 'package:quran/utils/theme_color.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.background,
      child: Text('Insight'),
    );
  }
}