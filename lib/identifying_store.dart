import 'dart:developer';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';
part 'identifying_store.g.dart';

class IdentifyingStore = _IdentifyingStore with _$IdentifyingStore;

abstract class _IdentifyingStore with Store {
  @observable
  String? identifyError;

  @observable
  GenerateContentResponse? response;

  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: 'AIzaSyBPD8Ij25WdN_VA4G8P-B8eC9iO7DPlC68',
  );

  @action
  Future<void> identifyImage(XFile image) async {
    try {
      final mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        identifyError = 'Invalid image type.';
        return;
      }

      final bytes = await image.readAsBytes();
      final prompt = TextPart('Please identify this plant and its disease.');

      response = await model.generateContent([
        Content.multi([
          prompt,
          DataPart(mimeType, bytes),
        ]),
      ]);
    } catch (e, stack) {
      log('Error: $e\n$stack');
      identifyError = 'An error occurred.';
    }
  }
}
