import 'package:galaxy/core/images.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [

  OnboardingContents(
    title: "Welcome to GALAXY",
    image: welcome,
    desc: "Effortless global procurement at your fingertips.",
  ),

  OnboardingContents(
    title: "Streamlined Import Solutions",
    image: import,
    desc: "Simplify your global procurement with our seamless import services.",
  ),
  OnboardingContents(
    title: "Global Export Excellence",
    image: export,
    desc:
    "Unlock new markets with our reliable and efficient export solutions.",
  ),
  OnboardingContents(
    title: "Smart Business Solutions",
    image: business,
    desc:
    "Enhance your operations with our expert business support and services.",
  ),
  OnboardingContents(
    title: "Express Courier Services",
    image: courier,
    desc:
    "Delivering your parcels quickly and securely, worldwide.",
  ),
  OnboardingContents(
    title: "Finish",
    image: done,
    desc: "You're all set! Start exploring now.",
  ),
];