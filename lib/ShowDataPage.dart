import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/myData.dart'; // Adjust import path if needed

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  List<myData> allData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final ref = FirebaseDatabase.instance.ref().child('node-name');
    final event = await ref.once();
    final snapshot = event.snapshot;

    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      allData.clear();

      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          final name = value['name']?.toString() ?? '';
          final message = value['message']?.toString() ?? '';
          final profession = value['profession']?.toString() ?? '';

          allData.add(myData(name, message, profession));
        }
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Data')),
      body: allData.isEmpty
          ? Center(child: Text('No Data is Available'))
          : ListView.builder(
              itemCount: allData.length,
              itemBuilder: (_, index) {
                return _buildCard(
                  allData[index].name,
                  allData[index].profession,
                  allData[index].message,
                );
              },
            ),
    );
  }

  Widget _buildCard(String name, String profession, String message) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name',
                style: Theme.of(context).textTheme.titleLarge),
            Text('Profession: $profession'),
            Text('Message: $message'),
          ],
        ),
      ),
    );
  }
}
