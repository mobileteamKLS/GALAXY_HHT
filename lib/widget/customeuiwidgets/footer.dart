import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/core/mycolor.dart';
import '../../module/splash/model/splashdefaultmodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../prefrence/savedprefrence.dart';
import '../../utils/sizeutils.dart';
import '../custometext.dart';

class FooterCompanyName extends StatefulWidget {
  const FooterCompanyName({super.key});

  @override
  State<FooterCompanyName> createState() => _FooterCompanyNameState();
}

class _FooterCompanyNameState extends State<FooterCompanyName> {
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  SplashDefaultModel? _splashDefaultData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCompanyData();


  }
  Future<void> _loadCompanyData() async {
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    setState(() {
      _splashDefaultData = splashDefaultData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical * 0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_splashDefaultData != null) ...[
            CustomeText(
              text: "App Version ${_splashDefaultData?.appVersion ?? ''}",
              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
              fontColor: MyColor.textColorGrey2,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),



          ],
        ],
      ),
    );
  }
}
