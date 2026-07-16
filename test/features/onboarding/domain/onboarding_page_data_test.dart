import 'package:beango/features/onboarding/domain/onboarding_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onboarding page data keeps immutable presentation values', () {
    const page = OnboardingPageData(
      title: 'Title',
      body: 'Body',
      artwork: OnboardingArtwork.taste,
      accent: Colors.amber,
    );

    expect(page.title, 'Title');
    expect(page.body, 'Body');
    expect(page.artwork, OnboardingArtwork.taste);
  });
}
