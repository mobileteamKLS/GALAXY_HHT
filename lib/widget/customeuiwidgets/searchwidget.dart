import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:galaxy/widget/groupidcustomtextfield.dart';

import '../../core/mycolor.dart';
import '../../language/appLocalizations.dart';
import '../../language/model/lableModel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/sizeutils.dart';
import '../customtextfield.dart';
import 'dart:ui' as ui;

class Searchwidget extends StatefulWidget {

  Function(String) searchingString;
  final Function(String, String)? updateSortingOptions;
  FocusNode? filtersearchFocusNode;

  Searchwidget({super.key, required this.searchingString, this.updateSortingOptions, this.filtersearchFocusNode});

  @override
  State<Searchwidget> createState() => _SearchwidgetState();
}

class _SearchwidgetState extends State<Searchwidget> {

  String _selectedActionSorting = '';
  String _selectedFilterSorting = '';

  @override
  Widget build(BuildContext context) {
    AppLocalizations? localizations = AppLocalizations.of(context);
    LableModel? lableModel = localizations!.lableModel;

    ui.TextDirection textDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;

   // print("Sorting === ${_selectedActionSorting} == ${_selectedFilterSorting}");

    return Row(
      children: [
        Expanded(
          child: GroupIdCustomTextField(
            textDirection: textDirection,
            focusNode: widget.filtersearchFocusNode,
            hasIcon: true,
            hastextcolor: true,
            animatedLabel: false,
            needOutlineBorder: true,
            isIcon: true,
            isSearch: true,

            prefixIconcolor: MyColor.colorBlack,
            hintText: "${lableModel!.filterByUld}",
            readOnly: false,

            onChanged: (value) {
              widget.searchingString(value);
            },
            fillColor: MyColor.colorWhite,
            textInputType: TextInputType.text,
            inputAction: TextInputAction.next,
            hintTextcolor: MyColor.colorBlack.withOpacity(0.7),
            verticalPadding: 0,
            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARBORDER,
            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please fill out this field";
              } else {
                return null;
              }
            },
          ),
        ),
        SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
        InkWell(
            onTap: () {
              _showPriceRangeDialog(lableModel);
            },
            child: SvgPicture.asset(filter, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),

      ],
    );
  }

  void _showPriceRangeDialog(LableModel lableModel) async {
    final Map<String, String?> selectedOptions = await DialogUtils.showSortRangeDialog(context, lableModel);
    if (selectedOptions.isNotEmpty) {
      _selectedActionSorting = selectedOptions['actionSorting'] ?? '';
      _selectedFilterSorting = selectedOptions['filterSorting'] ?? '';
      widget.updateSortingOptions!(_selectedActionSorting, _selectedFilterSorting);

    }
  }


}
