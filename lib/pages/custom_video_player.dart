// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class CustomVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final bool autoInitialize;
  final bool autoPlay;
  final Duration startAt;
  final bool looping;
  final bool showControls;
  final double aspectRatio;
  final Widget placeholder;

  CustomVideoPlayer(
    this.controller, {
    Key key,
    this.aspectRatio,
    this.autoInitialize = false,
    this.autoPlay = false,
    this.startAt,
    this.looping = false,
    this.placeholder = const Icon(
      FontAwesomeIcons.fileVideo,
      size: 36.0,
    ),
    this.showControls = true,
  })  : assert(controller != null,
            'You must provide a controller to play a video'),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return _PlayerWithControls(
      controller: _controller,
      aspectRatio: widget.aspectRatio ?? _calculateAspectRatio(context),
      placeholder: widget.placeholder,
      autoPlay: widget.autoPlay,
      showControls: widget.showControls,
    );
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller = widget.controller;
    _initialize();
  }

  Future _initialize() async {
    await _controller.setLooping(widget.looping);

    if (widget.autoInitialize) {
      await _controller.initialize();
    }

    if (widget.autoPlay) {
      await _controller.play().catchError(
          (dynamic error) => print('Video player  play error: $error'));
    } else {
      await _controller.pause().catchError(
          (dynamic error) => print('Video player pause error: $error'));
    }

    if (widget.startAt != null) {
      await _controller.seekTo(widget.startAt);
    }
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller.dataSource != _controller.dataSource) {
      _controller.dispose();
      _controller = widget.controller;
//      _initialize();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}

class _PlayerWithControls extends StatefulWidget {
  final VideoPlayerController controller;
  final Widget placeholder;
  final double aspectRatio;
  final bool autoPlay;
  final bool showControls;

  _PlayerWithControls({
    @required this.controller,
    @required this.aspectRatio,
    this.showControls = true,
    this.placeholder,
    this.autoPlay,
    Key key,
  }) : super(key: key);

  @override
  State createState() => _VideoPlayerWithControlsState();
}

class _VideoPlayerWithControlsState extends State<_PlayerWithControls> {
  bool isLoadingFailed;

  @override
  void initState() {
    super.initState();
    isLoadingFailed = false;
    _registerControllerListeners();
  }

  void _registerControllerListeners() {
    widget.controller.addListener(_onPlay);
    widget.controller.addListener(_onFailed);
  }

  void _removeControllerListeners() {
    widget.controller.removeListener(_onPlay);
    widget.controller.removeListener(_onFailed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: isLoadingFailed
              ? widget.placeholder
              : _buildPlayerWithControls(widget.controller, context),
        ),
      ),
    );
  }

  Container _buildPlayerWithControls(
      VideoPlayerController controller, BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          _Controls(
            controller: controller,
            autoPlay: widget.autoPlay,
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(_PlayerWithControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.dataSource != oldWidget.controller.dataSource) {
      _registerControllerListeners();
    }
  }

  void _onPlay() {
    if (widget.controller.value.isPlaying) {
      setState(_removeControllerListeners);
    }
  }

  void _onFailed() {
    if (widget.controller.value.hasError) {
      print(
          "\n============= error start ================\n\n  custom video player error: ${widget.controller.value.errorDescription}\n\n controller ${widget.controller.toString()}\n\n=============== error end ================\n");
      setState(() {
        isLoadingFailed = true;
      });
    }
  }

  @override
  void dispose() {
    _removeControllerListeners();
    super.dispose();
  }
}

class _Controls extends StatefulWidget {
  final VideoPlayerController controller;
  final bool autoPlay;

  _Controls({
    @required this.controller,
    @required this.autoPlay,
  });

  @override
  State<StatefulWidget> createState() => _ControlsState();
}

class _ControlsState extends State<_Controls> {
  VideoPlayerValue _latestValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
//      _latestValue != null && !_latestValue.isPlaying && _latestValue.duration == null || _latestValue.isBuffering
//          ? Expanded(
//        child: Center(
//          child: CircularProgressIndicator(),
//        ),
//      )
//          :
      _buildHitArea(),
    ]);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    widget.controller.removeListener(_updateState);
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(_Controls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.dataSource != oldWidget.controller.dataSource) {
      _dispose();
      _initialize();
    }
  }

  Expanded _buildHitArea() {
    return Expanded(
      child: GestureDetector(
        onTap: _playPause,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity:
                  _latestValue != null && !_latestValue.isPlaying && !_dragging
                      ? 1.0
                      : 0.0,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                child: Container(
                    child: Icon(FontAwesomeIcons.solidPlayCircle,
                        color: Colors.white, size: 60.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _initialize() async {
    widget.controller.addListener(_updateState);

    _updateState();

    if ((widget.controller.value != null &&
            widget.controller.value.isPlaying) ||
        widget.autoPlay) {}
  }

  void _playPause() {
    if (widget.controller.value.isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  void _pause() {
    setState(() {
      widget.controller.pause();
    });
  }

  void _play() {
    setState(() {
      if (!widget.controller.value.initialized) {
        widget.controller.initialize().then((_) {
          widget.controller.play();
        }).catchError((dynamic error) => print('Video player error: $error'));
      } else {
        if (widget.controller.value.position >=
            widget.controller.value.duration) {
          widget.controller.seekTo(Duration(seconds: 0));
        }
        widget.controller.play();
      }
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = widget.controller.value;
    });
  }
}
