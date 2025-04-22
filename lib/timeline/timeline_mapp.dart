import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineMapp extends StatefulWidget {
  const TimelineMapp({super.key});

  @override
  State<TimelineMapp> createState() => _TimelineMappState();
}

class _TimelineMappState extends State<TimelineMapp> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: TimelineTile(
                axis: TimelineAxis.horizontal,
                alignment: TimelineAlign.center,
                isLast: true,
                indicatorStyle: IndicatorStyle(
                  indicator: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey),
                      child: Center(child: Text('1'))),
                  indicatorXY: 1,
                ),
                beforeLineStyle: LineStyle()),
          ),
          SizedBox(
            width: 50,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey),
                    child: Center(child: Text('2'))),
                indicatorXY: 1,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey),
                    child: Center(child: Text('3'))),
                indicatorXY: 1,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey),
                    child: Center(child: Text('4'))),
                indicatorXY: 1,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey),
                    child: Center(child: Text('5'))),
                indicatorXY: 1,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                height: 32,
                width: 32,
                indicator: SvgPicture.asset(
                    'assets/images/locked_reward_box.svg'),
                indicatorXY: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
