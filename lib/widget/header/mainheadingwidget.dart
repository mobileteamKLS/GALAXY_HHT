import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../custometext.dart';

class MainHeadingWidget extends StatefulWidget {
  String mainMenuName;
  MainHeadingWidget({super.key, required this.mainMenuName});

  @override
  State<MainHeadingWidget> createState() => _MainHeadingWidgetState();
}

class _MainHeadingWidgetState extends State<MainHeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                MyColor.bggradientfirst, // #0060E5 color
                MyColor.bggradientsecond, // #1D86FF color
              ],
              stops: [
                0.0,
                1.0
              ], // Specifies the start and end of the gradient
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3, vertical: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(drawer, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                  CustomeText(text: widget.mainMenuName, fontColor: MyColor.colorWhite, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start)
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(usercog, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH6,),
                  SvgPicture.asset(bell, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
