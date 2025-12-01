
import 'package:flutter/material.dart';
import 'package:totto/common/widgets/default_image_widget.dart';

class ProductImageWidget extends StatelessWidget
{
    final String? imageUrl;
    final double? height;
    final double? width;
    final BoxFit fit;
    final BorderRadius borderRadius;

    const ProductImageWidget({
        super.key,
        required this.imageUrl,
        this.height,
        this.width,
        this.fit = BoxFit.cover,
        this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    });

    @override
    Widget build(BuildContext context) 
    {
        return ClipRRect(
            borderRadius: borderRadius,
            child: _buildImage(),
        );
    }

    Widget _buildImage() 
    {
        final url = imageUrl;

        if (url == null || url.isEmpty || !url.startsWith('http')) 
        {
            return DefaultImageWidget(size: (height ?? width ?? 80) * 0.5);
        }

        return Image.network(
            url,
            height: height,
            width: width,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress)
            {
                if (loadingProgress == null) return child;
                return const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.grey,
                    ),
                );
            },
            errorBuilder: (context, error, stackTrace)
            {
                return DefaultImageWidget(size: (height ?? width ?? 80) * 0.5);
            },
        );
    }
}
