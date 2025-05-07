import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight+50,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF3F3F3e)))),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
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
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      flex: 5,
                      child: Text('50000'),
                    ),
                    Expanded(
                      flex: 9,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: screenHeight / 5,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight / 5 - 20,
                                  width: 6,
                                  child: RotatedBox(
                                    quarterTurns: -3,
                                    child: LinearProgressIndicator(
                                      value: .5,
                                      color: color,
                                      backgroundColor: backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Container(
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
                                ),
                              ],
                            ),
                          ),
                          Expanded(
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
                                        width: 5,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
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
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/level_coin.svg'),
                            const Text('50000')
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
