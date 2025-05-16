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
  bool _isSearchActive = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isSearchActive = _focusNode.hasFocus;
    });
  }

  void _activateSearch() {
    setState(() {
      _isSearchActive = true;
    });
    _focusNode.requestFocus();
  }

  void _deactivateSearch() {
    _focusNode.unfocus();
    setState(() {
      _isSearchActive = false;
    });
    if (widget.controller.text.isNotEmpty) {
      widget.controller.clear();
      widget.onClear();
    }
  }

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
        _activateSearch();
      }
    } on PlatformException catch (e) {
      setState(() => _isListening = false);
      debugPrint("Voice input failed: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearchActive) {
      return Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search contacts',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _deactivateSearch,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onClear();
                    },
                  ),
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_none : Icons.mic,
                    color: Colors.grey[600],
                  ),
                  onPressed: _startVoiceInput,
                ),
              ],
            ),
          ),
          onChanged: widget.onChanged,
        ),
      );
  } else {
      return Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GestureDetector(
          onTap: _activateSearch,
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
                  child: Text(
                    'Search contacts',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_none : Icons.mic,
                    color: Colors.grey[600],
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _startVoiceInput,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}