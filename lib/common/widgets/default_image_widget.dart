
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultImageWidget extends StatelessWidget
{
    final double? size;
    const DefaultImageWidget({super.key, this.size});

    @override
    Widget build(BuildContext context) 
    {
        return SvgPicture.asset(
            'assets/default_image/totto_default_image.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,

            placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(strokeWidth: 2.0),
            ),
        );
    }
}
