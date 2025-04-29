import 'package:api_insert/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class Historyview extends StatefulWidget {
  const Historyview({super.key});

  @override
  State<Historyview> createState() => _HistoryviewState();
}

class _HistoryviewState extends State<Historyview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("History"),
      ),
      bottomNavigationBar: BottomNav(2),
    );
  }
}