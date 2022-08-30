import 'dart:math';
import 'package:candlesticks/src/controller/candlestick_chart_controller.dart';
import 'package:candlesticks/src/models/candle.dart';
import 'package:candlesticks/src/theme/theme_data.dart';
import 'package:candlesticks/src/widgets/toolbar_action.dart';
import 'package:candlesticks/src/widgets/mobile_chart.dart';
import 'package:candlesticks/src/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'models/candle.dart';

enum ChartAdjust {
  /// Will adjust chart size by max and min value from visible area
  visibleRange,

  /// Will adjust chart size by max and min value from the whole data
  fullRange
}

/// StatefulWidget that holds Chart's State (index of
/// current position and candles width).
class Candlesticks extends StatefulWidget {
  /// The arrangement of the array should be such that
  ///  the newest item is in position 0
  final List<Candle> candles;

  /// this callback calls when the last candle gets visible
  final Future<void> Function()? onLoadMoreCandles;

  /// list of buttons you what to add on top tool bar
  final List<ToolBarAction> actions;

  /// How chart price range will be adjusted when moving chart
  final ChartAdjust chartAdjust;

  /// Will zoom buttons be displayed in toolbar
  final bool displayZoomActions;

  /// Custom loader widget
  final Widget? loadingWidget;

  final CandlestickChartController? controller;

  final bool? displayCandleInfoText;

  Candlesticks(
      {Key? key,
      required this.candles,
      this.onLoadMoreCandles,
      this.actions = const [],
      this.chartAdjust = ChartAdjust.visibleRange,
      this.displayZoomActions = true,
      this.controller,
      this.loadingWidget,
      this.displayCandleInfoText})
      : assert(candles.length == 0 || candles.length > 1,
            "Please provide at least 2 candles"),
        super(key: key);

  @override
  _CandlesticksState createState() => _CandlesticksState();
}

class _CandlesticksState extends State<Candlesticks> {
  /// index of the newest candle to be displayed
  /// changes when user scrolls along the chart
  static int _defaultIndex = -1;
  int defaultIndex = _defaultIndex;
  int index = _defaultIndex;
  double lastX = 0;
  int lastIndex = _defaultIndex;

  /// candleWidth controls the width of the single candles.
  ///  range: [2...10]
  double candleWidth = 40;
  double scaleWidth = 40;

  /// true when widget.onLoadMoreCandles is fetching new candles.
  bool isCallingLoadMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    candleWidth = (widget.candles.length <= 7)
        ? 40
        : (widget.candles.length <= 30)
            ? 12
            : (widget.candles.length <= 90)
                ? 4
                : (widget.candles.length <= 180)
                    ? 2
                    : 1;
    defaultIndex = (widget.candles.length <= 7)
        ? -1
        : (widget.candles.length <= 30)
            ? -4
            : (widget.candles.length <= 90)
                ? -8
                : (widget.candles.length <= 180)
                    ? -16
                    : -24;
    widget.controller?.addListener(() {
      setState(() {
        candleWidth = (widget.candles.length <= 7)
            ? 40
            : (widget.candles.length <= 30)
                ? 12
                : (widget.candles.length <= 90)
                    ? 4
                    : (widget.candles.length <= 180)
                        ? 2
                        : 1;
        defaultIndex = (widget.candles.length <= 7)
            ? -1
            : (widget.candles.length <= 30)
                ? -4
                : (widget.candles.length <= 90)
                    ? -8
                    : (widget.candles.length <= 180)
                        ? -16
                        : -24;
        index = widget.controller?.index ?? 0;
        scaleWidth = candleWidth;
      });
    });
    widget.controller?.setIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToolBar(
          displayZoomActions: widget.displayZoomActions,
          onZoomInPressed: () {
            setState(() {
              scaleWidth += 2;
              scaleWidth = min(scaleWidth, 40);
              candleWidth = scaleWidth;
            });
          },
          onZoomOutPressed: () {
            setState(() {
              scaleWidth -= 2;
              scaleWidth = max(
                  scaleWidth,
                  (widget.candles.length <= 7)
                      ? 40
                      : (widget.candles.length <= 30)
                          ? 12
                          : (widget.candles.length <= 90)
                              ? 4
                              : (widget.candles.length <= 180)
                                  ? 2
                                  : 1);
              defaultIndex = (widget.candles.length <= 7)
                  ? -1
                  : (widget.candles.length <= 30)
                      ? -4
                      : (widget.candles.length <= 90)
                          ? -8
                          : (widget.candles.length <= 180)
                              ? -16
                              : -24;
              candleWidth = scaleWidth;
            });
          },
          children: widget.actions,
        ),
        if (widget.candles.length == 0)
          Expanded(
            child: Center(
              child: widget.loadingWidget ??
                  CircularProgressIndicator(
                    color: Theme.of(context).gold,
                  ),
            ),
          )
        else
          Expanded(
            child: TweenAnimationBuilder(
              tween: Tween(begin: 6.toDouble(), end: candleWidth),
              duration: Duration(milliseconds: 120),
              builder: (_, double width, __) {
                return MobileChart(
                  chartAdjust: widget.chartAdjust,
                  onScaleUpdate: (double scale) {
                    print(scale);
                    setState(() {
                      candleWidth = scale * scaleWidth;
                      candleWidth = min(candleWidth, 40);
                      candleWidth = max(
                          candleWidth,
                          (widget.candles.length <= 7)
                              ? 40
                              : (widget.candles.length <= 30)
                                  ? 12
                                  : (widget.candles.length <= 90)
                                      ? 4
                                      : (widget.candles.length <= 180)
                                          ? 2
                                          : 1);
                    });
                  },
                  onPanEnd: () {
                    lastIndex = index;
                    scaleWidth = candleWidth;
                  },
                  onHorizontalDragUpdate: (double x) {
                    setState(() {
                      x = x - lastX;
                      index = lastIndex + x ~/ candleWidth;
                      index = max(index, defaultIndex);
                      index = min(index, widget.candles.length - 1);
                    });
                  },
                  onPanDown: (double value) {
                    lastX = value;
                    lastIndex = index;
                  },
                  onReachEnd: () {
                    if (isCallingLoadMore == false &&
                        widget.onLoadMoreCandles != null) {
                      isCallingLoadMore = true;
                      widget.onLoadMoreCandles!().then((_) {
                        isCallingLoadMore = false;
                      });
                    }
                  },
                  candleWidth: width,
                  candles: widget.candles,
                  index: index,
                  displayCandleInfoText: widget.displayCandleInfoText,
                );
              },
            ),
          ),
      ],
    );
  }
}
