import 'dart:collection';

import 'package:flutter/material.dart';

const kLightGreen = const Color(0xFFC1E1DC);
const kShadowGreen = const Color(0xFF637C78);
const kMossGreen = const Color(0xFF4D5A58);
const kAccentGreen = const Color(0xFF40E0D0);
const kBrown900 = const Color(0xFF393737);
const kLightGray = const Color(0xFFC1C1C1);
const kButtonColor = const Color(0xFFECF5F4);
const kLightYellow = const Color(0xFFFFEB94);
const kWhite = Colors.white;
const kErrorRed = Colors.red;
const kAccentBlue = const Color(0xFF0091C5);

const kGradYellow = const Color(0xfffff884);
const kGradBlueGreen = const Color(0xff63e7e6);

const kGradCherryPink = const Color(0xffee9ca7);
const kGradLightPink = const Color(0xffffdde1);

const kGradNight = const Color(0xff654ea3);
const kGradSunRise = const Color(0xffeaafc8);

const kGradPinkRose = const Color(0xffE8CBC0);
const kGradBlueRose = const Color(0xff636FA4);

const kGradDeepSky = const Color(0xff005AA7);
const kGradEvening = const Color(0xffFFFDE4);

class ColorPair{
  Color base;
  Color spread;

  ColorPair(Color base, Color spread){
    this.base = base;
    this.spread = spread;
  }
}

class GradColors{
  
  Map<int, ColorPair> pairStore;

  GradColors() {
    pairStore = {
      0 : new ColorPair(kGradYellow, kGradBlueGreen),
      1 : new ColorPair(kGradCherryPink, kGradLightPink),
      2 : new ColorPair(kGradNight, kGradSunRise),
      3 : new ColorPair(kGradPinkRose, kGradBlueRose),
      4 : new ColorPair(kGradDeepSky, kGradEvening)
    };
  }
}