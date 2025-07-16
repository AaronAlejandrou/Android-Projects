import 'package:flutter/material.dart';

class AddCommentDialog extends StatefulWidget {
  const AddCommentDialog({super.key});

  @override
  State<AddCommentDialog> createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  final _controller = TextEditingController();
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Your comment'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Rating:'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _rating,
                items: List.generate(5, (i) => i + 1)
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                    .toList(),
                onChanged: (v) => setState(() => _rating = v ?? 5),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isEmpty) return;
            Navigator.pop(context, {
              'content': _controller.text.trim(),
              'rating': _rating,
            });
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
} 