import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ShowDataPage.dart'; // Update the path if needed

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _key = GlobalKey();
  bool _autoValidate = false;
  String name = '';
  String profession = '';
  String message = '';

  final List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
      child: Text('Student'),
      value: 'Student',
    ),
    DropdownMenuItem(
      child: Text('Professor'),
      value: 'Professor',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Database'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _key,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: _buildFormUI(),
        ),
      ),
    );
  }

  Widget _buildFormUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Name'),
                validator: _validateName,
                onSaved: (val) => name = val ?? '',
                maxLength: 32,
              ),
            ),
            SizedBox(width: 10.0),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: items,
                hint: Text('Profession'),
                value: profession.isNotEmpty ? profession : null,
                onChanged: (val) {
                  setState(() {
                    profession = val ?? '';
                  });
                },
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(hintText: 'Message'),
          onSaved: (val) => message = val ?? '',
          validator: _validateMessage,
          maxLines: 5,
          maxLength: 256,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _sendToServer,
          child: Text('Send'),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowDataPage()),
            );
          },
          child: Text('Show Data'),
        ),
      ],
    );
  }

  void _sendToServer() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState?.save();

      final ref = FirebaseDatabase.instance.ref().child('node-name');

      final data = {
        "name": name,
        "profession": profession,
        "message": message,
      };

      await ref.push().set(data);
      _key.currentState?.reset();
      setState(() {
        profession = '';
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String? _validateName(String? val) {
    if (val == null || val.isEmpty) return "Enter Name First";
    return null;
  }

  String? _validateMessage(String? val) {
    if (val == null || val.isEmpty) return "Enter Message First";
    return null;
  }
}
