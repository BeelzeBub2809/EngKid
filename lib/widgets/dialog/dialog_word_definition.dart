import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/utils/translation_service.dart';

class DialogWordDefinition extends StatefulWidget {
  final Map<String, dynamic> wordInfo;

  const DialogWordDefinition({
    super.key,
    required this.wordInfo,
  });

  @override
  State<DialogWordDefinition> createState() => _DialogWordDefinitionState();
}

class _DialogWordDefinitionState extends State<DialogWordDefinition> {
  late FlutterTts flutterTts;
  bool isPlaying = false;
  bool isTranslating = false;
  String? translatedDefinition;
  bool showVietnamese = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();

    // Configure TTS settings
    await flutterTts.setLanguage("en-GB"); // UK English voice
    await flutterTts.setSpeechRate(0.4); // Slower speech rate for clarity
    await flutterTts.setVolume(1.0); // Maximum volume for louder voice
    await flutterTts.setPitch(1.0);

    // Set completion handler
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });

    // Set error handler
    flutterTts.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
        LibFunction.toast('Speech error: $msg');
      }
    });
  }

  Future<void> _speakPronunciation() async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
        setState(() {
          isPlaying = false;
        });
        return;
      }

      setState(() {
        isPlaying = true;
      });

      // Speak the word for pronunciation
      String wordToSpeak = widget.wordInfo['word'].toString();
      await flutterTts.speak(wordToSpeak);
    } catch (e) {
      setState(() {
        isPlaying = false;
      });
      LibFunction.toast('Could not play pronunciation');
    }
  }

  Future<void> _translateDefinition() async {
    if (translatedDefinition != null) {
      // Toggle between English and Vietnamese
      setState(() {
        showVietnamese = !showVietnamese;
      });
      return;
    }

    setState(() {
      isTranslating = true;
    });

    try {
      final englishDefinition = widget.wordInfo['definition'].toString();
      final vietnameseDefinition =
          await TranslationService.translateToVietnamese(englishDefinition);

      setState(() {
        translatedDefinition = vietnameseDefinition;
        showVietnamese = true;
        isTranslating = false;
      });
    } catch (e) {
      setState(() {
        isTranslating = false;
      });
      LibFunction.toast('Không thể dịch định nghĩa');
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.8, // Limit dialog height to 80% of screen
          maxWidth: size.width * 0.9, // Limit dialog width to 90% of screen
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.wordInfo['word'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20, // Reduced from 24
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Reduced from 16

                // Part of Speech
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.wordInfo['partOfSpeech'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Reduced from 16

                // Pronunciation
                Row(
                  children: [
                    const Icon(Icons.record_voice_over,
                        color: Colors.orange, size: 18), // Reduced icon size
                    const SizedBox(width: 6), // Reduced spacing
                    const Text(
                      'Pronunciation: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13), // Reduced font size
                    ),
                    Expanded(
                      child: Text(
                        widget.wordInfo['pronunciation'],
                        style: const TextStyle(
                          fontSize: 14, // Reduced from 16
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _speakPronunciation,
                      icon: Icon(
                        isPlaying ? Icons.stop : Icons.volume_up,
                        color: isPlaying ? Colors.red : Colors.green,
                      ),
                      tooltip: isPlaying
                          ? 'Stop pronunciation'
                          : 'Play pronunciation',
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Reduced from 16

                // Definition
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description,
                        color: Colors.green, size: 18), // Reduced icon size
                    const SizedBox(width: 6), // Reduced spacing
                    Text(
                      showVietnamese
                          ? 'Định nghĩa (VI): '
                          : 'Definition (EN): ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13), // Reduced font size
                    ),
                    const Spacer(),
                    // Translate button
                    InkWell(
                      onTap: isTranslating ? null : _translateDefinition,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: showVietnamese
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: showVietnamese ? Colors.blue : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isTranslating
                                ? const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Icon(
                                    showVietnamese
                                        ? Icons.language
                                        : Icons.translate,
                                    size: 14,
                                    color: showVietnamese
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                            const SizedBox(width: 4),
                            Text(
                              isTranslating
                                  ? 'Đang dịch...'
                                  : showVietnamese
                                      ? 'Tiếng Anh'
                                      : 'Tiếng Việt',
                              style: TextStyle(
                                fontSize: 11,
                                color: showVietnamese
                                    ? Colors.blue
                                    : Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6), // Reduced from 8
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.3, // Limit definition height
                  ),
                  padding: const EdgeInsets.all(10), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      showVietnamese && translatedDefinition != null
                          ? translatedDefinition!
                          : widget.wordInfo['definition'],
                      style: const TextStyle(
                        fontSize: 13, // Reduced from 14
                        height: 1.3, // Reduced line height
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Reduced from 20

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Close',
                        style: TextStyle(fontSize: 14)), // Reduced font size
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
