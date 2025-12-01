import 'package:flutter/material.dart';
import 'dart:io';
import 'package:totto/common/widgets/default_image_widget.dart';

class OrderHistoryCard extends StatelessWidget
{
    final Color cardColor;
    final String productName;
    final String quantity;
    final String price;
    final String imageUrl;
    final String buttonText;
    final VoidCallback onButtonPressed;
    final Color textColor;
    final String statusDisplay;
    final bool isAdmin;
    final VoidCallback? onStatusPressed;

    const OrderHistoryCard({
        super.key,
        required this.cardColor,
        required this.productName,
        required this.quantity,
        required this.price,
        required this.imageUrl,
        required this.buttonText,
        required this.onButtonPressed,
        this.textColor = Colors.white,
        required this.statusDisplay,
        this.isAdmin = false,
        this.onStatusPressed,
    });

    @override
    Widget build(BuildContext context) 
    {
        return Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 4,
            shadowColor: cardColor.withOpacity(0.3),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            12.0),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            12.0),
                                        child: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                const DefaultImageWidget(size: 40),
                                            )
                                            : const DefaultImageWidget(size: 40),
                                    ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                            Text(
                                                productName,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                                quantity,
                                                style: TextStyle(
                                                    color: textColor
                                                        .withOpacity(0.9),
                                                    fontSize: 14,
                                                ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                                price,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                ),
                                            ),
                                            const SizedBox(height: 8,),
                                            _buildStatusChip(),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: onButtonPressed,
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: textColor,
                                    side: BorderSide(
                                        color: textColor, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                ),
                                child: Text(
                                    buttonText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }


Widget _buildStatusChip() {
    return GestureDetector(
        onTap: isAdmin ? onStatusPressed : null,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Text(
                        'Status: $statusDisplay',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            decoration: isAdmin ? TextDecoration.underline : TextDecoration.none,
                            decorationStyle: isAdmin ? TextDecorationStyle.dotted : null,
                            decorationColor: textColor,
                            ),
                        ),
                    if (isAdmin)
                        Icon(Icons.arrow_drop_down, size: 16, color: textColor),
                    ],
                ),
             ),
        );
    }
}