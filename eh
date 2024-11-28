
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'record_infos.dart';
import 'dart:typed_data';

extension IntExtension on int {
  String toHexString() {
    return '0x' + toRadixString(16).padLeft(2, '0').toUpperCase();
  }
}

extension Uint8ListExtension on Uint8List {
  String toHexString({String empty = '-', String separator = ' '}) {
    return isEmpty ? empty : map((e) => e.toHexString()).join(separator);
  }
}

class NdefRecordInfo {
  const NdefRecordInfo(
      {required this.record, required this.title, required this.subtitle});

  final Record record;

  final String title;

  final String subtitle;

  static NdefRecordInfo fromNdef(NdefRecord record) {
    final _record = Record.fromNdef(record);
    if (_record is WellknownTextRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Text',
        subtitle: '(${_record.languageCode}) ${_record.text}',
      );
    if (_record is WellknownUriRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Uri',
        subtitle: '${_record.uri}',
      );
    if (_record is MimeRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Mime',
        subtitle: '(${_record.type}) ${_record.dataString}',
      );
    if (_record is AbsoluteUriRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Absolute Uri',
        subtitle: '(${_record.uriType}) ${_record.payloadString}',
      );
    if (_record is ExternalRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'External',
        subtitle: '(${_record.domainType}) ${_record.dataString}',
      );
    if (_record is UnsupportedRecord) {
      // more custom info from NdefRecord.
      if (record.typeNameFormat == NdefTypeNameFormat.empty)
        return NdefRecordInfo(
          record: _record,
          title: _typeNameFormatToString(_record.record.typeNameFormat),
          subtitle: '-',
        );
      return NdefRecordInfo(
        record: _record,
        title: _typeNameFormatToString(_record.record.typeNameFormat),
        subtitle:
            '(${_record.record.type.toHexString()}) ${_record.record.payload.toHexString()}',
      );
    }
    throw UnimplementedError();
  }
}

String _typeNameFormatToString(NdefTypeNameFormat format) {
  switch (format) {
    case NdefTypeNameFormat.empty:
      return 'Empty';
    case NdefTypeNameFormat.nfcWellknown:
      return 'NFC Wellknown';
    case NdefTypeNameFormat.media:
      return 'Media';
    case NdefTypeNameFormat.absoluteUri:
      return 'Absolute Uri';
    case NdefTypeNameFormat.nfcExternal:
      return 'NFC External';
    case NdefTypeNameFormat.unknown:
      return 'Unknown';
    case NdefTypeNameFormat.unchanged:
      return 'Unchanged';
  }
}

class NfcSerialNumberRetriever extends StatefulWidget {
  @override
  _NfcSerialNumberRetrieverState createState() =>
      _NfcSerialNumberRetrieverState();
}

class _NfcSerialNumberRetrieverState extends State<NfcSerialNumberRetriever> {
  String? serialNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Serial Number Retriever'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              serialNumber != null
                  ? 'Serial Number: $serialNumber'
                  : 'Scan an NFC tag to retrieve the serial number',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNfcScan,
              child: Text('Scan NFC Tag'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startNfcScan() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        setState(() {
          serialNumber = 'NFC is not available on this device';
        });
        return;
      }

      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        try {
          // Retrieve the identifier (serial number) from the NFC tag
          final identifier = tag.data['nfca']['identifier'] as Uint8List?;
          if (identifier != null) {
            setState(() {
              serialNumber = identifier.toHexString(separator: ':');
            });
          } else {
            setState(() {
              serialNumber = 'Serial number not found';
            });
          }
        } catch (e) {
          setState(() {
            serialNumber = 'Error retrieving serial number: $e';
          });
        } finally {
          NfcManager.instance.stopSession();
        }
      });
    } catch (e) {
      setState(() {
        serialNumber = 'Error: $e';
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: NfcSerialNumberRetriever(),
  ));
}


