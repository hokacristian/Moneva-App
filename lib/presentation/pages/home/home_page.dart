import 'package:flutter/material.dart';
import 'package:moneva/presentation/pages/form/input_form_page.dart';
import 'package:moneva/presentation/pages/form/history_input_page.dart';
import 'package:moneva/presentation/pages/outcome/outcome_page.dart';
import 'package:moneva/presentation/pages/dampak/dampak_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {"title": "Input Form", "icon": Icons.assignment, "page": InputFormPage()},
    {"title": "History Form", "icon": Icons.history, "page": HistoryInputPage()},
    {"title": "Outcome", "icon": Icons.analytics, "page": OutcomePage()},
    {"title": "Dampak", "icon": Icons.bar_chart, "page": DampakPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitur Aplikasi"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return _buildFeatureCard(
              context, 
              features[index]["title"], 
              features[index]["icon"], 
              features[index]["page"],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
