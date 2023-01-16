
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final bool play;

  const VideoWidget({Key key, @required this.url, @required this.play})
      : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.url,
        cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true));
    _controller = BetterPlayerController(BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);

    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: double.infinity,
      height: 250,
      child: BetterPlayer(controller: _controller),
    );
  }
}
