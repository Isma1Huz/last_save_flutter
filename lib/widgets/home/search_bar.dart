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

  static const Color micButtonColor = Color(0xFF3ED2D0);

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

  Widget _buildMicButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: micButtonColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _isListening ? Icons.mic_none : Icons.mic,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    const containerColor = Color(0xFFE8ECF4);
    
    final searchInputColor = isDark ? theme.cardColor : Colors.white;
    
    final iconColor = isDark ? theme.iconTheme.color : Colors.grey[600];
    final textColor = isDark ? theme.textTheme.bodyMedium?.color : Colors.grey[600];
    
    if (_isSearchActive) {
      return Container(
        color: isDark ? theme.scaffoldBackgroundColor : containerColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Container(
          decoration: BoxDecoration(
            color: searchInputColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Search contacts',
              hintStyle: TextStyle(color: isDark ? theme.hintColor : Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              prefixIcon: IconButton(
                icon: Icon(Icons.arrow_back, color: iconColor),
                onPressed: _deactivateSearch,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: iconColor),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onClear();
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: _startVoiceInput,
                      child: _buildMicButton(),
                    ),
                  ),
                ],
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
      );
    } else {
      return Container(
        color: isDark ? theme.scaffoldBackgroundColor : containerColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GestureDetector(
          onTap: _activateSearch,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: searchInputColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search contacts',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _startVoiceInput,
                  child: _buildMicButton(),
                ),
                if (widget.onMoreTap != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onMoreTap,
                    child: Icon(Icons.more_vert, color: iconColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }
}
