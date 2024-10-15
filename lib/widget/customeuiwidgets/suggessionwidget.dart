import 'package:flutter/cupertino.dart';
import 'package:galaxy/language/model/lableModel.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';

import '../../core/mycolor.dart';
import '../custometext.dart';

class SuggessionWidget extends StatelessWidget {
  LableModel lableModel;
  String suggestionMessage;
  SuggessionWidget({super.key, required this.lableModel, required this.suggestionMessage});

  @override
  Widget build(BuildContext context) {

   // String? suggestionMessage = lableModel.getValueFromKey(suggestionCode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: CustomeText(text: "${lableModel.suggest} : ${suggestionMessage}", fontColor: MyColor.colorGreen, fontSize: SizeConfig.textMultiplier * 1.7, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
    );
  }
}
