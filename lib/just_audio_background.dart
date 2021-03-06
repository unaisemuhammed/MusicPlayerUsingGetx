import 'dart:math';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;final Duration position;final ValueChanged<Duration>? onChanged;final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    required this.duration, required this.position, this.onChanged, this.onChangeEnd,});

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {double? _dragValue;late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(trackHeight: 2.0,);}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [SliderTheme(data: _sliderThemeData.copyWith(inactiveTrackColor: Colors.grey, thumbColor: Colors.white, activeTrackColor: Colors.white),
          child: Slider(min: 0.0, max: widget.duration.inMilliseconds.toDouble(), value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()), onChanged: (value) {
              setState(() {_dragValue = value;});
              if (widget.onChanged != null) {widget.onChanged!(Duration(milliseconds: value.round()));}},
            onChangeEnd: (value) {if (widget.onChangeEnd != null) {widget.onChangeEnd!(Duration(milliseconds: value.round()));}_dragValue = null;},),),
        Positioned(
          bottom: -4, right: 25,
          child: Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch('$_remaining')?.group(1) ?? '$_remaining',
              style: const TextStyle(color: Colors.white70,fontFamily: 'Geman', fontSize: 18)),
        ),
        Positioned(
          bottom: -4, left: 25,
          child: Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch('$_position')?.group(1) ?? '$_position',
              style: const TextStyle(color: Colors.white70,fontFamily: 'Geman',fontSize: 18)),),],);}
  Duration get _remaining => widget.duration;Duration get _position => widget.position;}


class PositionData {final Duration position;final Duration duration;PositionData(this.position, this.duration);}
