
import 'package:flutter/material.dart';

const Map<String, Color> urgencyBackgroundColors = 
{
    'NORMAL': Color(0xFFEFF6FF),
    'HIGH': Color(0xFFF0FDF4),
    'URGENT': Color(0xFFFEF2F2),
};

const Map<String, Color> urgencyTextColors = 
{
    'NORMAL': Color(0xFF1E40AF),
    'HIGH': Color(0xFF166534),
    'URGENT': Color(0xFF991B1B),
};

Color getUrgencySolidColor(String urgency) {
    switch (urgency.toUpperCase()) {
        case 'URGENT':
            return const Color(0xFFEF4444);
        case 'HIGH':
            return const Color(0xFF22C55E);
        case 'NORMAL':
        default:
            return const Color(0xFF3B82F6);
    }
}

Color getUrgencyBackgroundColor(String urgency)
{
    return urgencyBackgroundColors[urgency.toUpperCase()] ?? urgencyBackgroundColors['NORMAL']!;
}

Color getUrgencyTextColor(String urgency)
{
    return urgencyTextColors[urgency.toUpperCase()] ?? urgencyTextColors['NORMAL']!;
}
