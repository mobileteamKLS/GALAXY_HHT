import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customdivider.dart';

import '../../module/login/model/userlogindatamodel.dart';
import '../../module/splash/model/splashdefaultmodel.dart';
import '../../module/submenu/model/submenumodel.dart';
import '../../module/submenu/page/submenupage.dart';
import '../custometext.dart';
import '../groupidcustomtextfield.dart';

class BuildCustomeDrawer extends StatefulWidget {

  List<SubMenuName>? importSubMenuList = [];
  List<SubMenuName>? exportSubMenuList = [];
  UserDataModel user;
  SplashDefaultModel splashDefaultData;
  final VoidCallback onDrawerCloseIcon;

  BuildCustomeDrawer({super.key,
    this.importSubMenuList,
    this.exportSubMenuList,
    required this.user, required this.splashDefaultData, required this.onDrawerCloseIcon});

  @override
  State<BuildCustomeDrawer> createState() => _BuildCustomeDrawerState();
}

class _BuildCustomeDrawerState extends State<BuildCustomeDrawer> {

  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  bool isImportExpanded = false;
  bool isExportExpanded = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.90, // Set to 75% of screen width
      color: MyColor.colorWhite,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(widget.splashDefaultData.clientLogo!, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8, width: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8, fit: BoxFit.cover,),
                        InkWell(
                            onTap: widget.onDrawerCloseIcon,
                            child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,))
                      ],
                    ),
                  ),
                  CustomDivider(
                    space: 0,
                    color: MyColor.textColorGrey,
                    hascolor: true,
                    thickness: 1,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomeText(text: "PROFILE", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: MyColor.bottomBorderColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: MyColor.dropdownColor,
                              radius: SizeConfig.blockSizeVertical *  SizeUtils.TEXTSIZE_2_3,
                              child: CustomeText(
                                text: "${widget.user.userProfile?.firstName?[0]}",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                fontColor:  MyColor.textColorBlueHigh,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE,),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomeText(
                                    text: "${widget.user.userProfile?.firstName} ${widget.user.userProfile?.lastName}",
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    fontColor:  MyColor.textColorGrey3,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                  CustomeText(
                                    text: "${widget.user.userProfile?.userGroup}",
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    fontColor:  MyColor.textColorGrey3,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,),
                                ],
                              ),
                            ),
                            SvgPicture.asset(logout, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_6 ,),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH6,),
                            SvgPicture.asset(more, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_6 ,)
                          ],
                        ),



                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomeText(text: "SERVICES", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: MyColor.bgColorGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            GroupIdCustomTextField(
                              controller: searchEditingController,
                              focusNode: searchFocusNode,
                              hasIcon: true,
                              hastextcolor: true,
                              animatedLabel: false,
                              needOutlineBorder: true,
                              isShowPrefixIcon: true,

                              isIcon: true,
                              isSearch: true,
                              prefixIconcolor: MyColor.colorBlack,
                              hintText: "Search Menu",
                              readOnly: false,
                              onChanged: (value) async {



                              },
                              fillColor: MyColor.colorWhite,
                              textInputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              hintTextcolor: MyColor.colorBlack.withOpacity(0.7),
                              verticalPadding: 0,
                              maxLength: 15,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARBORDER,
                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                              isDigitsOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this field";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(dashboard, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),
                                        SizedBox(width: 15,),
                                        CustomeText(
                                          text: "Dashboard",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                 /* Container(
                                    decoration: BoxDecoration(
                                      color: (isImportExpanded) ? MyColor.textColorBlueHigh : MyColor.bgColorGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _buildMenuItem(
                                        icon: importSvg,
                                        title: "Import (${widget.importSubMenuList!.length})",
                                        isExpanded: isImportExpanded,
                                        onIconTap: () {
                                          setState(() {
                                            isImportExpanded = !isImportExpanded;
                                          });
                                        },
                                        subMenuList: isImportExpanded ? widget.importSubMenuList : null,

                                      ),
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            SvgPicture.asset(exportSvg, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),
                                            SizedBox(width: 20,),
                                            CustomeText(
                                              text: "Import (0)",
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontColor:  MyColor.textColorGrey3,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                          ],
                                        ),
                                        SvgPicture.asset(circleDown, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            SvgPicture.asset(exportSvg, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),
                                            SizedBox(width: 20,),
                                            CustomeText(
                                              text: "Export (${widget.exportSubMenuList!.length})",
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontColor:  MyColor.textColorGrey3,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                          ],
                                        ),
                                        SvgPicture.asset(circleDown, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(courrierSvg, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),
                                        SizedBox(width: 10,),
                                        CustomeText(
                                          text: "Courrier",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),



                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomeText(text: "APP INFO", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        decoration: BoxDecoration(
                          color: MyColor.pinkColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(manual, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),
                                        SizedBox(width: 20,),
                                        CustomeText(
                                          text: "Product Manual",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(comments, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,),
                                        SizedBox(width: 12,),
                                        CustomeText(
                                          text: "FAQ",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3, color: MyColor.textColorGrey3 ,),
                                        SizedBox(width: 15,),
                                        CustomeText(
                                          text: "App release note",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),



                      )
                    ],
                  )

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: MyColor.bgColorGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomeText(
                  text: "KLSPL",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontColor:  MyColor.textColorGrey2,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                CustomeText(
                  text: "App Build ${widget.splashDefaultData.appVersion}",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontColor:  MyColor.textColorGrey2,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onIconTap,
    List<SubMenuName>? subMenuList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(icon,
                    height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3, color: (isExpanded) ? MyColor.colorWhite : MyColor.colorBlack,),
                SizedBox(width: 20),
                CustomeText(text: title,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontColor: (isExpanded) ? MyColor.colorWhite : MyColor.textColorGrey3,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,)
              ],
            ),
            InkWell(
              onTap: onIconTap,
              child: SvgPicture.asset(isExpanded ? circleUp : circleDown,
                  height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3),
            ),
          ],
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: (subMenuList != null && isExpanded) ? Row(
              children: [
                Container(
                  width: 1, // Adjust the width of the vertical line
                  height: subMenuList.length * 35.0, // Adjust height based on number of items
                  color: MyColor.colorWhite,
                  margin: const EdgeInsets.only(left: 12, top: 8, right: 30), // Align the line with items
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: subMenuList.map((subMenu) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child:    CustomeText(text: subMenu.menuName!,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400,
                          fontColor: (isExpanded) ? MyColor.colorWhite : MyColor.textColorGrey3,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ) : Container(),
        ),

      ],
    );
  }
}
