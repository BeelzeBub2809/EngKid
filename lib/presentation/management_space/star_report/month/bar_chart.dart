import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/utils/app_color.dart';

class _BarChart extends StatelessWidget {
  const _BarChart({required this.data, required this.maxY});

  final List<DayOf> data;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(
          show: false,
        ),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        allowTouchBarBackDraw: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return null;
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: AppColor.gray, width: 0.8),
        ),
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Color(0XFF64ae86),
          Color(0XFF64ae86),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _barsGradientOrgane => const LinearGradient(
        colors: [
          Color(0XFFf26a24),
          Color(0XFFf26a24),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => List.generate(
        data.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: double.parse(data[index].value.toString()),
              gradient:
                  data[index].isHighlight ? _barsGradientOrgane : _barsGradient,
              width: 38,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
}

class BarCharStar extends StatefulWidget {
  const BarCharStar({super.key, required this.data, required this.maxY});

  final List<DayOf> data;
  final double maxY;

  @override
  State<StatefulWidget> createState() => BarCharStarState();
}

class BarCharStarState extends State<BarCharStar> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 20 / 9,
        child: _BarChart(data: widget.data, maxY: widget.maxY));
  }
}
