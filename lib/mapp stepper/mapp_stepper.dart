import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timelines_plus/timelines_plus.dart';

class MappStepper extends StatefulWidget {
  const MappStepper({super.key});

  @override
  State<MappStepper> createState() => _MappStepperState();
}

class _MappStepperState extends State<MappStepper> {
  int initialPage = 0;
  int currentStep = 2;
  int totalSteps = 4;
  int currentStep1 = 2;
  int currentStep2 = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          FixedTimeline.tileBuilder(
            direction: Axis.horizontal,
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              connectorBuilder: (context, index, type) {
                return Container(
                  height: 5,
                  width: 25,
                  color: Colors.yellow,
                );
              },
              firstConnectorBuilder: (context) {
                return Container(
                  height: 5,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                );
              },
              lastConnectorBuilder: (context) {
                return Container(
                  height: 5,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                );
              },
              indicatorBuilder: (context, index) {
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Center(
                    child: Text('${index + 1}'),
                  ),
                );
              },
              indicatorPositionBuilder: (context, index) {
                // Pull first and last indicators slightly inward to expose wider connectors
                if (index == 0) return 0.65;
                if (index == totalSteps - 1) return 0.35;
                return 0.5;
              },
              itemExtentBuilder: (context, index) {
                // Give extra space at the first and last to allow longer connectors to show
                if (index == 0 || index == totalSteps - 1) return 68;
                return 50;
              },
              itemCount: totalSteps,
            ),
          ),
          SvgPicture.asset('assets/images/unlocked_reward_box.svg')
        ],
      ),
    );
  }
}
