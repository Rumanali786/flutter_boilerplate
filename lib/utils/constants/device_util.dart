import 'package:flutter/material.dart';

class DeviceUtils {


  static double isMobile(BuildContext context) => MediaQuery.of(context).size.shortestSide;

 static bool useMobileLayout(BuildContext context) => isMobile(context) < 600;
}