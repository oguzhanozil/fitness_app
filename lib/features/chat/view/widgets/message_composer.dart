import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';

class MessageComposer extends StatelessWidget {
  const MessageComposer({
    super.key,
    required this.fieldKey,
    required this.initialText,
    required this.onChanged,
    required this.isBusy,
    required this.onSend,
  });

  final Key fieldKey;
  final String initialText;
  final ValueChanged<String> onChanged;
  final bool isBusy;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        border: Border(
          top: BorderSide(color: ThemeColors.woodBorder.withValues(alpha: 0.30)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              key: fieldKey,
              initialValue: initialText,
              enabled: !isBusy,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onChanged: onChanged,
              onFieldSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Ask your coach something...',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: ThemeColors.woodBorder.withValues(alpha: 0.35),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: ThemeColors.woodBorder.withValues(alpha: 0.35),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: ThemeColors.coachesAppBarBackground),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: isBusy ? null : onSend,
            style: FilledButton.styleFrom(
              backgroundColor: ThemeColors.coachesAppBarBackground,
              foregroundColor: ThemeColors.coachesAppBarForeground,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
