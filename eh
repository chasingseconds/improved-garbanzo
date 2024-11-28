To retrieve the serial 
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NfcReadScreen(),
    );
  }
}

class NfcReadScreen extends StatefulWidget {
  @override
  _NfcReadScreenState createState() => _NfcReadScreenState();
}

class _NfcReadScreenState extends State<NfcReadScreen> {
  String _serialNumber = 'Tap an NFC tag';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NFC Serial Number')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _serialNumber,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNfcSession,
              child: Text('Scan NFC Tag'),
            ),
          ],
        ),
      ),
    );
  }

  void _startNfcSession() async {
    if (!await NfcManager.instance.isAvailable()) {
      setState(() {
        _serialNumber = 'NFC is not available on this device.';
      });
      return;
    }

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        // Extract the UID (serial number) of the NFC tag
        Uint8List? id = tag.data['ndef']?['identifier'] ?? tag.data['id'];
        if (id != null) {
          setState(() {
            _serialNumber = id.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
          });
        } else {
          setState(() {
            _serialNumber = 'Failed to retrieve the serial number.';
          });
        }
      } catch (e) {
        setState(() {
          _serialNumber = 'Error: $e';
        });
      } finally {
        NfcManager.instance.stopSession();
      }
    });
  }
}

Key Points:

1. NFC Tag Serial Number (UID):

The tag's unique identifier (UID) is often stored in the id field or inside the ndef data of the NfcTag.



2. Reading the UID:

The UID is extracted as a Uint8List, and it is converted to a hexadecimal string for readability.



3. Error Handling:

The code includes checks to ensure NFC is available and gracefully handles errors during the session.



4. UI:

The app shows the serial number in the UI and allows rescanning with a button.




Steps to Test:

1. Add the nfc_manager dependency in your pubspec.yaml.


2. Ensure NFC is enabled on your device.


3. Tap an NFC tag, and the app should display its serial number.



This implementation covers reading and displaying the NFC tag's serial number effectively.

