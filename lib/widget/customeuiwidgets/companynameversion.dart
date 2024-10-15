import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../module/splash/model/splashdefaultmodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../prefrence/savedprefrence.dart';
import '../custometext.dart';

class CompanyNameVersion extends StatefulWidget {

  Color? color;
  CompanyNameVersion({super.key, required this.color});

  @override
  State<CompanyNameVersion> createState() => _CompanyNameVersionState();
}

class _CompanyNameVersionState extends State<CompanyNameVersion> {
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  SplashDefaultModel? _splashDefaultData;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();


  }
  Future<void> _loadCompanyData() async {
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (splashDefaultData != null) {
      setState(() {
        _splashDefaultData = splashDefaultData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);


    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_splashDefaultData != null) ...[
            CustomeText(
              text: "${_splashDefaultData?.appVersion ?? ''} KLSPL 2024",
              fontSize: SizeConfig.textMultiplier * 1.5,
              fontColor: widget.color!,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}