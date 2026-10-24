import 'dart:async';

import 'package:flutter/material.dart';

class QuoteCarousel extends StatefulWidget {
  const QuoteCarousel({super.key});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  static const quotes = [
    'Big goals are tiny tasks in a trench coat.',
    'Study now. Let your pillow be proud later.',
    'Plot twist: you are actually making progress.',
    'Your future self called. One more task, please.',
    'Brain loading... keep going, you have got this.',
  ];

  final PageController controller = PageController();
  Timer? timer;
  int page = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!controller.hasClients) return;
      controller.animateToPage(
        (page + 1) % quotes.length,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFE5F2E9),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 17,
              color: Color(0xFF117C78),
            ),
            SizedBox(width: 8),
            Text(
              'A LITTLE BOOST',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: Color(0xFF117C78),
              ),
            ),
            Spacer(),
            Text(
              'SWIPE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF667782),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: PageView.builder(
            controller: controller,
            itemCount: quotes.length,
            onPageChanged: (index) => setState(() => page = index),
            itemBuilder: (context, index) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                quotes[index],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: Color(0xFF172B3A),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        Row(
          children: List.generate(
            quotes.length,
            (index) => Container(
              width: index == page ? 18 : 6,
              height: 6,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: index == page
                    ? const Color(0xFF117C78)
                    : const Color(0xFFB6D8C6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
