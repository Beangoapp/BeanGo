import 'package:flutter/material.dart';

enum OnboardingArtwork { taste, discover, moment }

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.body,
    required this.artwork,
    required this.accent,
  });

  final String title;
  final String body;
  final OnboardingArtwork artwork;
  final Color accent;
}
