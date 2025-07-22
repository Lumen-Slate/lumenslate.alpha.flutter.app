import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class AddCorpusFilePayload {
  final String corpusName;
  final PlatformFile file;

  AddCorpusFilePayload({
    required this.corpusName,
    required this.file,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'corpusName': corpusName,
      'file': MultipartFile.fromBytes(file.bytes!, filename: file.name),
    });
  }
}

