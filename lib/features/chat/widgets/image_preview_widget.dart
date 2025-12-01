import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/features/chat/utils/urgency_helpers.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/chat/websocket/providers/chat_controller.dart';

class ImagePreviewWidget extends ConsumerStatefulWidget
{
    const ImagePreviewWidget({
        super.key,
        required this.imageFile,
        required this.params,
    });

    final File imageFile;
    final ChatConnectionParams params;

    @override
    ConsumerState<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends ConsumerState<ImagePreviewWidget>
{
    final _captionController = TextEditingController();

    String _selectedUrgency = 'NORMAL';
    final List<String> _urgencyLevels = const['NORMAL', 'HIGH', 'URGENT'];

    @override
    void dispose() 
    {
        _captionController.dispose();
        super.dispose();
    }

    void _cycleUrgency() 
    {
        setState(()
            {
                final currentIndex = _urgencyLevels.indexOf(_selectedUrgency);
                final nextIndex = (currentIndex + 1) % _urgencyLevels.length;
                _selectedUrgency = _urgencyLevels[nextIndex];
            }
        );
    }

    void _sendImageWithCaption() 
    {
        final caption = _captionController.text.trim();
        ref.read(chatControllerProvider(widget.params).notifier).sendImageMessage(
            widget.imageFile,
            widget.params,
            content: caption.isNotEmpty ? caption : null,
            urgency: _selectedUrgency,
        );
        Navigator.of(context).pop();
    }

    @override
    Widget build(BuildContext context) 
    {
        final Map<String, IconData> urgencyIcons = 
        {
            'NORMAL': Icons.flag_outlined,
            'HIGH': Icons.flag,
            'URGENT': Icons.flag,
        };
        final Map<String, Color> urgencyIconColors = 
        {
            'NORMAL': Colors.white70,
            'HIGH': getUrgencyTextColor('HIGH'),
            'URGENT': getUrgencyTextColor('URGENT'),
        };

        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
            ),
            body: Column(
                children: [
                    Expanded(
                        child: Center(
                            child: Image.file(
                                widget.imageFile,
                                fit: BoxFit.contain,
                            ),
                        ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: SafeArea(
                            child: Row(
                                children: [
                                    IconButton(
                                        iconSize: 28,
                                        tooltip: 'Set message urgency',
                                        icon: Icon(
                                            urgencyIcons[_selectedUrgency],
                                            color: urgencyIconColors[_selectedUrgency],
                                        ),
                                        onPressed: _cycleUrgency,
                                    ),
                                    Expanded(
                                        child: TextField(
                                            controller: _captionController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                                hintText: 'Add a caption...',
                                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                                filled: true,
                                                fillColor: Colors.grey.shade900,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                    borderSide: BorderSide.none,
                                                ),
                                                contentPadding:
                                                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(width: 8),
                                    FloatingActionButton(
                                        onPressed: _sendImageWithCaption,
                                        backgroundColor: Colors.red,
                                        child: const Icon(Icons.send, color: Colors.white),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
