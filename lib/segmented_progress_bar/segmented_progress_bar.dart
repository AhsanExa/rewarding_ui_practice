import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewarding_ui_practice/segmented_progress_bar/custom_widget/progress_indicator_with_tooltip/progress_indicator_with_tooltip.dart';

class QuestProgress {
  final String goalAmount;
  final double progressValue;
  final String incentive;

  QuestProgress({
    required this.goalAmount,
    required this.progressValue,
    required this.incentive,
  });
}

final questLevels = [
  QuestProgress(goalAmount: '৳৫,০০০', progressValue: 1, incentive: '৳১০'),
  QuestProgress(goalAmount: '৳১০,০০০', progressValue: 1, incentive: '৳২৫'),
  QuestProgress(goalAmount: '৳২০,০০০', progressValue: .1, incentive: '৳৫০'),
  QuestProgress(goalAmount: '৳৫০,০০০', progressValue: 0, incentive: '৳৭০'),
  QuestProgress(goalAmount: '৳১,০০,০০০', progressValue: 0, incentive: '৳১০০'),
  QuestProgress(goalAmount: '৳১,৫০,০০০', progressValue: 0, incentive: '৳১৫০'),
];

class SegmentedProgressBar extends StatefulWidget {
  const SegmentedProgressBar({super.key});

  @override
  State<SegmentedProgressBar> createState() => _SegmentedProgressBarState();
}

class _SegmentedProgressBarState extends State<SegmentedProgressBar> {
  Color getRandomColor() {
    final random = Random();
    return Color(0xFF000000 | random.nextInt(0x00FFFFFF));
  }

  final Color color = const Color(0xFFE2136E);
  final Color backgroundColor = const Color(0xFFDDDDDD);
  final Color currentBackgroundColor = const Color(0xFFFDEFF4);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const currentLevel = 3;
    return SizedBox(
      height: screenHeight + 100,
      child: Column(
        children: [
          const QuestTableHeader(),
          const SizedBox(
            height: 12,
          ),
          const Row(
            children: [Text('৳০')],
          ),
          QuestTableDynamicBody(
              questLevels: questLevels,
              currentLevel: currentLevel,
              color: color,
              backgroundColor: backgroundColor,
              currentBackgroundColor: currentBackgroundColor)
        ],
      ),
    );
  }
}

class QuestTableHeader extends StatelessWidget {
  const QuestTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF3F3F3)))),
      child: const Row(
        children: [
          Expanded(
            flex: 6,
            child: Text('লক্ষ্য'),
          ),
          Expanded(
            flex: 9,
            child: Text('অগ্রগতি'),
          ),
          Expanded(
            flex: 4,
            child: Text('ইনসেনটিভ'),
          ),
        ],
      ),
    );
  }
}

class QuestTableDynamicBody extends StatelessWidget {
  const QuestTableDynamicBody({
    super.key,
    required this.questLevels,
    required this.currentLevel,
    required this.color,
    required this.backgroundColor,
    required this.currentBackgroundColor,
  });

  final List<QuestProgress> questLevels;
  final int currentLevel;
  final Color color;
  final Color backgroundColor;
  final Color currentBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final levels = questLevels.length;
    return Flexible(
      child: ListView.builder(
        itemCount: levels,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              QuestGoalSection(questLevelItem: questLevels[index]),
              QuestProgressbarSection(
                index: index,
                questLevelItem: questLevels[index],
                progressHeight: screenHeight/levels,
                currentLevel: currentLevel,
                color: color,
                backgroundColor: backgroundColor,
                currentBackgroundColor: currentBackgroundColor,
              ),
              QuestIncentiveSection(questLevelItem: questLevels[index])
            ],
          );
        },
      ),
    );
  }
}

class QuestGoalSection extends StatelessWidget {
  const QuestGoalSection({
    super.key,
    required this.questLevelItem,
  });

  final QuestProgress questLevelItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Text(questLevelItem.goalAmount),
    );
  }
}

class QuestProgressbarSection extends StatelessWidget {
  const QuestProgressbarSection({
    super.key,
    required this.index,
    required this.questLevelItem,
    required this.progressHeight,
    required this.currentLevel,
    required this.color,
    required this.backgroundColor,
    required this.currentBackgroundColor,
  });

  final int index;
  final QuestProgress questLevelItem;
  final double progressHeight;
  final int currentLevel;
  final Color color;
  final Color backgroundColor;
  final Color currentBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: progressHeight,
            child: Column(
              children: [
                SizedBox(
                  height: progressHeight - 20,
                  width: 6,
                  child: RotatedBox(
                    quarterTurns: -3,
                    child: LinearProgressIndicatorWithTooltip(
                      value: questLevelItem.progressValue,
                      color: color,
                      backgroundColor: (index == currentLevel - 1)
                          ? currentBackgroundColor
                          : backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      showTooltip: (index == currentLevel-1),
                    ),
                  ),
                ),
                (questLevelItem.progressValue == 1)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    )
                  : Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                      ),
                    ),
              ],
            ),
          ),
          HorizontalDashedLine(dashColor: backgroundColor)
        ],
      ),
    );
  }
}

class QuestIncentiveSection extends StatelessWidget {
  const QuestIncentiveSection({super.key, required this.questLevelItem});

  final QuestProgress questLevelItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/level_coin.svg'),
          const SizedBox(
            width: 4.0,
          ),
          Text(questLevelItem.incentive)
        ],
      ),
    );
  }
}

class HorizontalDashedLine extends StatelessWidget {
  const HorizontalDashedLine({super.key, required this.dashColor});

  final Color dashColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SizedBox(
                height: 2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 18,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          height: 2,
                          width: (index == 0 || index == 17) ? 2 : 6,
                          decoration: BoxDecoration(
                            color: dashColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


