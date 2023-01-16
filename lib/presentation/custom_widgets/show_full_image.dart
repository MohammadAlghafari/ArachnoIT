import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowFullImage extends StatelessWidget {
  final String imageUrl;
  final bool withBaseUrl;
  ShowFullImage({@required this.imageUrl, @required this.withBaseUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: ChachedNetwrokImageView(
            imageUrl: imageUrl,
            autoWidthAndHeigh: true,
            showFullImageWhenClick: false,
          ),
        ),
      ),
    );
  }
}
