import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final VoidCallback? onMoreTap;

  const SearchInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.onMoreTap,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  static const platform = MethodChannel('voice_recognizer');
  bool _isListening = false;

  Future<void> _startVoiceInput() async {
    try {
      setState(() => _isListening = true);
      final result = await platform.invokeMethod<String>('startVoiceInput');
      setState(() => _isListening = false);
      if (result != null && result.isNotEmpty) {
        widget.controller.text = result;
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
        widget.onChanged(result);
      }
    } on PlatformException catch (e) {
      setState(() => _isListening = false);
      debugPrint("Voice input failed: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                decoration: const InputDecoration(
                  hintText: 'Ask your ai…',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  fillColor: Colors.white
                ),
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: _startVoiceInput,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3ED2D0), // Turquoise
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isListening ? Icons.mic_none : Icons.mic,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
