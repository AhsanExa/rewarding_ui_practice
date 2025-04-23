import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

const digitMapping = {
  '1': '১',
  '2': '২',
  '3': '৩',
  '4': '৪',
  '5': '৫',
  '6': '৬',
  '7': '৭',
  '8': '৮',
  '9': '৯',
  '10': '১0',
  '11': '১১',
  '12': '১২',
  '13': '১৩',
  '14': '১৪',
  '15': '১৫',
  '16': '১৬',
  '17': '১৭',
  '18': '১৮',
  '19': '১৯',
  '20': '২0',
};

class SteppedProgressBar extends StatefulWidget {
  const SteppedProgressBar({super.key});

  @override
  State<SteppedProgressBar> createState() => _SteppedProgressBarState();
}

class _SteppedProgressBarState extends State<SteppedProgressBar> {
  int currentStep = 2;
  int totalSteps = 7;
  Color selectedColor = const Color(0xFFFFCC59);
  Color unselectedColor = const Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    double singleWidth = (width - 38.4) / totalSteps;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width - 38.4,
              child: StepProgressIndicator(
                totalSteps: totalSteps,
                currentStep: currentStep,
                size: 20,
                padding: 0,
                customSize: (index, selected) => 30,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                roundedEdges: const Radius.circular(10),
                customStep: (index, color, _) => SizedBox(
                  width: singleWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      index == 0
                          ? Container(
                              width: singleWidth - 20,
                              height: 5,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                            )
                          : index == (totalSteps - 1)
                              ? Container(
                                  width: singleWidth,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: singleWidth - 20,
                                  height: 5,
                                  color: color,
                                ),
                      index == (totalSteps - 1)
                          ? Container()
                          : Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text('${digitMapping['${index + 1}']}'),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              height: 32,
              width: 32,
              fit: BoxFit.contain,
              currentStep == (totalSteps - 1)
                  ? 'assets/images/unlocked_reward_box.svg'
                  : 'assets/images/locked_reward_box.svg',
            )
          ],
        ),
      ),
    );
  }
}
