import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SteppedProgressBar extends StatefulWidget {
  const SteppedProgressBar({super.key});

  @override
  State<SteppedProgressBar> createState() => _SteppedProgressBarState();
}

class _SteppedProgressBarState extends State<SteppedProgressBar> {
  int initialPage = 0;
  int currentStep = 2;
  int totalSteps = 4;
  int currentStep1 = 2;
  int currentStep2 = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: SizedBox(
        width: 200,
        child: StepProgressIndicator(
          totalSteps: totalSteps,
          currentStep: totalSteps,
          size: 20,
          padding: 0,
          customSize: (index, selected) => 50,
          selectedColor: Colors.amber,
          unselectedColor: Colors.grey,
          roundedEdges: const Radius.circular(10),
          customStep: (index, color, _) => color == Colors.black
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              index == 0
                  ? Container(
                width: 25,
                height: 5,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )),
              )
                  : Container(
                width: 25,
                height: 5,
                color: color,
              ),
              index == (totalSteps - 1)
                  ? SvgPicture.asset(
                  'assets/images/locked_reward_box.svg')
                  : Container(
                height: 25,
                width: 20,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle),
              ),
            ],
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              index == 0
                  ? Container(
                width: 25,
                height: 5,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    )),
              )
                  : Container(
                width: 25,
                height: 5,
                color: color,
              ),
              index == (totalSteps - 1)
                  ? SvgPicture.asset(
                  'assets/images/locked_reward_box.svg')
                  : Container(
                  height: 25,
                  width: 20,
                  decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle)),
            ],
          ),
        ),
      ),
    );
  }
}
