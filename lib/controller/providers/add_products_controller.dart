import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class PickedImage {
  final String name;
  final Uint8List bytes;

  PickedImage({required this.name, required this.bytes});
}

Future<PickedImage?> pickImageFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
    withData: true, 
  );

  if (result != null && result.files.first.bytes != null) {
    final file = result.files.first;
    return PickedImage(name: file.name, bytes: file.bytes!);
  }

  return null;
}

void handlePick() async {
  final picked = await pickImageFile();

  if (picked != null) {
    print("Picked: ${picked.name}, Size: ${picked.bytes.length} bytes");

    // Now you can upload to Supabase
    // await supabase.storage.from('your-bucket').uploadBinary(
    //   'path/${picked.name}',
    //   picked.bytes,
    //   fileOptions: FileOptions(contentType: 'image/jpeg'),
    // );
  } else {
    print("No file selected.");
  }
}
