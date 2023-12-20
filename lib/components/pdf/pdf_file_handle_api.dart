import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_data_controller.dart';

class PdfFileHandlerApi {
  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file, AppDataController db) async {

    final url = file.path;
    await OpenFile.open(url).then((value) => db.setLoader(false));
  }
}
