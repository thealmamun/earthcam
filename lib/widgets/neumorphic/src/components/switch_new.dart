import 'package:earth_cam/widgets/neumorphic/src/animations/animated_scale.dart';
import 'package:flutter/widgets.dart';

import '../../neumorphic.dart';
import '../params.dart';

/// A style to customize the [NeuSwitchNew]
///
/// you can define the track : [activeTrackColor], [inactiveTrackColor], [trackDepth]
///
/// you can define the thumb : [activeTrackColor], [inactiveTrackColor], [thumbDepth]
/// and [curveType] @see [CurveType]
///
class NeuSwitchNewStyle {
  const NeuSwitchNewStyle({
    this.trackDepth,
    this.curveType = CurveType.concave,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbDepth,
    this.disableDepth,
  });

  final double trackDepth;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color activeThumbColor;
  final Color inactiveThumbColor;
  final CurveType curveType;
  final double thumbDepth;
  final bool disableDepth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeuSwitchNewStyle &&
          runtimeType == other.runtimeType &&
          trackDepth == other.trackDepth &&
          activeTrackColor == other.activeTrackColor &&
          inactiveTrackColor == other.inactiveTrackColor &&
          activeThumbColor == other.activeThumbColor &&
          inactiveThumbColor == other.inactiveThumbColor &&
          curveType == other.curveType &&
          thumbDepth == other.thumbDepth &&
          disableDepth == other.disableDepth;

  @override
  int get hashCode =>
      trackDepth.hashCode ^
      activeTrackColor.hashCode ^
      inactiveTrackColor.hashCode ^
      activeThumbColor.hashCode ^
      inactiveThumbColor.hashCode ^
      curveType.hashCode ^
      thumbDepth.hashCode ^
      disableDepth.hashCode;
}

/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of the switch changes, the widget calls the onChanged callback.
/// Most widgets that use a switch will listen for the onChanged callback and rebuild the switch with a new value to update the visual appearance of the switch.
///
/// ```
///  bool _switch1Value = false;
///  bool _switch2Value = false;
///
///  Widget _buildSwitches() {
///    return Row(children: <Widget>[
///
///      NeuSwitchNew(
///        value: _switch1Value,
///        style: NeuSwitchNewStyle(
///          curveType: CurveType.concave,
///        ),
///        onChanged: (value) {
///          setState(() {
///            _switch1Value = value;
///          });
///        },
///      ),
///
///      NeuSwitchNew(
///        value: _switch2Value,
///        style: NeuSwitchNewStyle(
///          curveType: CurveType.flat,
///        ),
///        onChanged: (value) {
///          setState(() {
///            _switch2Value = value;
///          });
///        },
///      ),
///
///    ]);
///  }
///  ```
///
@immutable
class NeuSwitchNew extends StatelessWidget {
  const NeuSwitchNew({
    this.style = const NeuSwitchNewStyle(),
    Key key,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 200),
    this.value = false,
    this.onChanged,
    this.height = 40,
    this.isEnabled = true,
  }) : super(key: key);

  static const MIN_EMBOSS_DEPTH = -1.0;

  final bool value;
  final ValueChanged<bool> onChanged;
  final NeuSwitchNewStyle style;
  final double height;
  final Duration duration;
  final Curve curve;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final NeuThemeData theme = NeuTheme.of(context);
    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: GestureDetector(
          onTap: () {
            // animation breaking prevention
            if (!isEnabled) {
              return;
            }
            if (onChanged != null) {
              onChanged(!value);
            }
          },
          child: NeuCard(
            // drawSurfaceAboveChild: false,
            // boxShape: NeumorphicBoxShape.stadium(),
            curveType: CurveType.emboss,
            decoration: NeumorphicDecoration(
              borderRadius: BorderRadius.circular(24),
              // disableDepth: style.disableDepth,
              // depth: _getTrackDepth(theme.depth),
              // shape: CurveType.flat,
              color: _getTrackColor(theme),
            ),
            child: AnimatedScale(
              scale: isEnabled ? 1 : 0,
              child: AnimatedThumb(
                curve: curve,
                disableDepth: style.disableDepth,
                depth: _thumbDepth,
                duration: duration,
                alignment: _alignment,
                shape: _getCurveType,
                thumbColor: _getThumbColor(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment get _alignment {
    if (value) {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }

  double get _thumbDepth {
    if (!isEnabled) {
      return 0;
    } else
      return style.thumbDepth;
  }

  CurveType get _getCurveType => style.curveType ?? CurveType.flat;

  // double _getTrackDepth(double themeDepth) {
  //   //force negative to have emboss
  //   final double depth = -1 * (this.style.trackDepth ?? themeDepth).abs();
  //   return depth.clamp(Neumorphic.MIN_DEPTH, NeuSwitchNew.MIN_EMBOSS_DEPTH);
  // }

  Color _getTrackColor(NeuThemeData theme) => value == true
      ? style.activeTrackColor ?? theme.backgroundColor
      : style.inactiveTrackColor ?? theme.backgroundColor;

  Color _getThumbColor(NeuThemeData theme) {
    // final Color color =
    //     value == true ? style.activeThumbColor : style.inactiveThumbColor;
    // return color ?? theme.backgroundColor;
    return Color(0xFFFFFFFF);
  }
}

class AnimatedThumb extends StatelessWidget {
  AnimatedThumb({
    Key key,
    this.thumbColor,
    this.alignment,
    this.duration,
    this.shape,
    this.disableDepth,
    this.depth,
    this.curve,
  }) : super(key: key);

  final Color thumbColor;
  final Alignment alignment;
  final Duration duration;
  final CurveType shape;
  final double depth;
  final Curve curve;
  final bool disableDepth;

  @override
  Widget build(BuildContext context) => AnimatedAlign(
        curve: curve,
        alignment: alignment,
        duration: duration,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: NeuCard(
            bevel: 30,
            curveType: CurveType.concave,
            decoration: NeumorphicDecoration(
              shape: BoxShape.circle,
              // disableDepth: this.disableDepth,
              // shape: shape,
              // depth: this.depth,
              color: thumbColor,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: FractionallySizedBox(
                heightFactor: 1,
                child: Container(),
                //width: THUMB_WIDTH,
              ),
            ),
          ),
        ),
      );
}
