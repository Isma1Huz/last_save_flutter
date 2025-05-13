// Flutter Side: lib/widgets/search/search_input.dart
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
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: 'Search contacts',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged,
              ),
            ),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic_none : Icons.mic,
                color: Colors.grey[600],
              ),
              onPressed: _startVoiceInput,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: widget.onMoreTap ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
