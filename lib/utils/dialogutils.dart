import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/language/model/dashboardModel.dart';
import 'package:galaxy/language/model/lableModel.dart';
import 'package:galaxy/module/export/services/buildup/builduplogic/buildupcubit.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackcubit.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackstate.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldlogic/unloaduldcubit.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldlogic/unloaduldstate.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/utils/validationmsgcodeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customebuttons/roundbuttongreen.dart';
import 'package:galaxy/widget/roundbutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import '../core/images.dart';
import '../module/export/model/palletstock/designtype.dart';
import '../module/export/model/palletstock/palletstackuldconditioncodemodel.dart';
import '../module/export/services/buildup/builduplogic/buildupstate.dart';
import '../module/import/model/uldacceptance/buttonrolesrightsmodel.dart';
import '../module/import/pages/uldacceptance/ulddamagedpage.dart';
import '../module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import '../module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import '../module/import/services/uldacceptance/uldacceptancelogic/uldacceptancecubit.dart';
import '../module/login/model/userlogindatamodel.dart';
import '../module/login/services/loginlogic/logincubit.dart';
import '../module/login/services/loginlogic/loginstate.dart';
import '../module/splash/model/splashdefaultmodel.dart';
import '../widget/customdivider.dart';
import '../widget/customeedittext/customeedittextwithborder.dart';
import '../widget/customeedittext/remarkedittextfeild.dart';
import '../widget/custometext.dart';
import '../widget/customtextfield.dart';
import 'dart:ui' as ui;

import '../widget/groupidcustomtextfield.dart';

class DialogUtils {
  static bool _isDialogShowing = false;

  static List<String> actionSortingOptions = [
    'Pending',
    'Accepted',
  ];

  static List<String> filterSortingOptions = [
    'A - Z',
    'Z - A',
  ];


  static String selectedActionSorting = '';
  static String selectedFilterSorting = '';

  static Future<bool?> showLogoutDialog(BuildContext context, DashboardModel dashboardModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${dashboardModel.logout}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${dashboardModel.logoutMsg}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${dashboardModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${dashboardModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  static Future<bool?> showExitAppDialog(BuildContext context, DashboardModel dashboardModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${dashboardModel.exit}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${dashboardModel.exitMsg}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${dashboardModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${dashboardModel.exit}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  static Future<bool?> showFlightFinalizeDialog(BuildContext context, LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${lableModel.finalizeflight}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${lableModel.finalizeflightMsg}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context, {String? message}) {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Returning false disables back button press
              return false;
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: MyColor.bggradientfirst),
                  if (message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomeText(
                        text: message,
                        fontColor: MyColor.colorWhite,
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static void hideLoadingDialog(BuildContext context) {
    if (_isDialogShowing) {
      _isDialogShowing = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static String formatMessage(String template, List<String> values) {
    String formattedMessage = template;
    for (int i = 0; i < values.length; i++) {
      formattedMessage = formattedMessage.replaceAll('{$i}', values[i]);
    }
    return formattedMessage;
  }

  static Future<bool?> showULDBDCompleteDialog(BuildContext context, LableModel lableModel, String uldNo, int uldProgress, String bdEndStatus, int shipmentList) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${lableModel.breakdown}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
         // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                decoration : BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (shipmentList != 0)
                      ? MyColor.lightYeloPendingColor
                      : MyColor.flightFinalize
                ),
                child: CustomeText(text: (shipmentList != 0) ?  formatMessage("${lableModel.pendingShipmentMsg}", ["$shipmentList"]) : "${lableModel.noPendingShipmentMsg}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w500),
              ),


              const SizedBox(height: 10,),
              CustomeText(text: (bdEndStatus == "Y") ? "${lableModel.breakdownAlreadyCompleted}" : (uldNo.contains("BULK")) ? formatMessage(lableModel.breakdownMsgBulk!, [uldNo]) : formatMessage(lableModel.breakdownMsgUld!, [uldNo]),fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: (bdEndStatus == "N") ? "${lableModel.no}" : "${lableModel.ok}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            (bdEndStatus == "N") ? SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,) : Container(),

            (bdEndStatus == "N") ? InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${lableModel.yes}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)) : Container(),

          ],
        );
      },
    );
  }

  static Future<bool?> showRevokeDialog(BuildContext context, LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${lableModel.revokeDamage}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: CustomeText(text: "${lableModel.revokeDamageMsg}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  static Future<bool?> showExpectedPiecesDialog(BuildContext context, LableModel lableModel, int enterpieces, int npxpieces) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${lableModel.excessPieces}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomeText(text: formatMessage(lableModel.receivesPiecesMsg!, ["${enterpieces}", "${npxpieces}"]),fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
              SizedBox(height: 10,),
              CustomeText(text: "${lableModel.breakdownPiecesMsg}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w500),

            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  static Future<bool?> showingActivateTimerDialog(BuildContext context, String userId, int companyCode){
    TextEditingController mPinController = TextEditingController();
    String errorText = "";
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  backgroundColor: MyColor.colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Set custom corner radius
                  ),
                  content: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginActivateSuccess) {

                        if(state.userDataModel.status == "E"){
                          Vibration.vibrate(duration: 500);
                        }else{
                          Navigator.of(context).pop(true);  // Correctly dismiss the dialog
                        }
                      }else if(state is LoginActivateFailure){
                        Vibration.vibrate(duration: 500);
                        setState(() {
                          errorText = state.error;
                        });
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Your dialog UI components, such as CustomTextField, buttons, etc.
                          CustomeText(
                            text: "Activate M-PIN",
                            fontColor: MyColor.colorRed,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                          CustomTextField(
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "Enter M-Pin",
                            readOnly: false,
                            controller: mPinController,
                            maxLength: 8,
                            onChanged: (value) {
                              setState(() {
                                errorText = "";
                              });
                            },
                            fillColor: Colors.grey.shade100,
                            textInputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black,
                            verticalPadding: 0,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                            digitsOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill out this field";
                              } else {
                                return null;
                              }
                            },
                          ),


                          if (errorText.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomeText(
                                text: errorText,
                                fontColor: MyColor.colorRed,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                          Row(
                            children: [
                              Expanded(
                                child: RoundedButton(
                                  text: "Logout",
                                  color: MyColor.colorRed,
                                  press: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: RoundedButton(
                                  text: (state is LoginLoading) ? "Loading..." : "Activate",
                                  color: MyColor.primaryColorblue,
                                  press: () {
                                    setState(() {
                                      errorText = "";
                                    });

                                    bool isValid = true;

                                    if (mPinController.text.isEmpty) {
                                      setState(() {
                                        errorText = "Please enter M-Pin";
                                      });
                                      isValid = false;
                                    } else if (mPinController.text.length < 6 ||
                                        mPinController.text.length > 8) {
                                      setState(() {
                                        errorText = "M-Pin between 6 to 8 digits";
                                      });
                                      isValid = false;
                                    }

                                    if (isValid) {
                                      context.read<LoginCubit>().loginActivate(
                                        userId,
                                        mPinController.text,
                                        "M",
                                        companyCode,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
              );
            },
          ),
        );
      },
    );
  }

  static void showDataNotFoundDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel, color: MyColor.colorRed, size: SizeConfig.blockSizeVertical * 10),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              CustomeText(
                text: message,
                fontColor: MyColor.colorBlack,
                fontSize: SizeConfig.textMultiplier * 2.2,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              RoundedButtonBlue(
                text: "Ok",
                color: MyColor.primaryColorblue,
                press: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool?> showDataNotFoundDialogbot(BuildContext context, String message, LableModel lableModel) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1, // Adjust the width to 100% of the screen width
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, color: MyColor.colorRed, size: SizeConfig.blockSizeVertical * 8),
                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                CustomeText(
                  text: message,
                  fontColor: MyColor.colorBlack,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                RoundedButtonBlue(
                  text: "${lableModel.ok}",
                  press: () {
                    Navigator.pop(context, true); // Return true when "Ok" is pressed
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<Map<String, String?>> showSortRangeDialog(BuildContext context, LableModel lableModel) async {

    // Temporary variables to hold the state of selections
   /* String tempActionSorting = '';
    String tempFilterSorting = '';*/

    // Show the dialog
    final result = await showModalBottomSheet<Map<String, String?>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(
                          text: "${lableModel.sortBy}",
                          fontColor: MyColor.primaryColorblue,
                          fontSize: SizeConfig.textMultiplier * 1.9,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),

                        InkWell(
                            onTap: () {
                              setState(() {
                                CommonUtils.tempActionSorting = '';
                                CommonUtils.tempFilterSorting = '';
                              });
                            },
                            child: Row(
                              children: [
                                 Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: SvgPicture.asset(redo, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                ),
                                CustomeText(text: lableModel.clear!, fontColor: MyColor.colorRed, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(
                          text: "${lableModel.action} : ",
                          fontColor: MyColor.primaryColorblue,
                          fontSize: SizeConfig.textMultiplier * 1.7,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: actionSortingOptions.map((sorting) {
                            return ChoiceChip(
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: MyColor.primaryColorblue,
                              label: Text(sorting),
                              labelStyle: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color:  CommonUtils.tempActionSorting == sorting
                                      ? MyColor.colorWhite
                                      : Colors.black45,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              selected:  CommonUtils.tempActionSorting == sorting,
                              onSelected: (bool selected) {
                                setState(() {
                                  CommonUtils.tempActionSorting = selected ? sorting : '';
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color:  CommonUtils.tempActionSorting == sorting
                                      ? MyColor.primaryColorblue
                                      : MyColor.colorWhite,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(
                          text: "${lableModel.filter} : ",
                          fontColor: MyColor.primaryColorblue,
                          fontSize: SizeConfig.textMultiplier * 1.7,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: filterSortingOptions.map((sorting) {
                            return ChoiceChip(
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: MyColor.primaryColorblue,
                              label: Text(sorting),
                              labelStyle: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color:  CommonUtils.tempFilterSorting == sorting
                                      ? MyColor.colorWhite
                                      : Colors.black45,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              selected:  CommonUtils.tempFilterSorting == sorting,
                              onSelected: (bool selected) {
                                setState(() {
                                  CommonUtils.tempFilterSorting = selected ? sorting : '';
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color:  CommonUtils.tempFilterSorting == sorting
                                      ? MyColor.primaryColorblue
                                      : MyColor.colorWhite,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    RoundedButtonBlue(
                      text: "${lableModel.apply}",
                      press: () {
                        Navigator.pop(context, {
                          'actionSorting':  CommonUtils.tempActionSorting,
                          'filterSorting':  CommonUtils.tempFilterSorting,
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );


    return result ?? {'actionSorting': CommonUtils.tempActionSorting, 'filterSorting': CommonUtils.tempFilterSorting};
  }


  static Future<int?> showBottomULDDialog(BuildContext context, String message, int damageNop, String damageConditionCode, LableModel lableModel, String uldDamageAcceptStatus,  List<ButtonRight> buttonRightsList) {


    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1, // Adjust the width to 90% of the screen width
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 2,
              horizontal: SizeConfig.blockSizeHorizontal * 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomeText(
                  text: message,
                  fontColor: MyColor.colorBlack,
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),

                uldDamageAcceptStatus == "A" ?  CustomeText(
                  text: message.contains('BULK') ? "${lableModel.bulkAcceptStatus}"  : "${lableModel.uldAcceptStatus}",
                  fontColor: MyColor.colorRed,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ) : const SizedBox(),
                uldDamageAcceptStatus == "A" ? SizedBox(height: SizeConfig.blockSizeVertical * 2) : const SizedBox(),
                Row(
                  children: [
                    message.contains('BULK') ? SizedBox() : Expanded(
                      flex: 1,
                      child: RoundedButton(
                        text: "${lableModel.damage}",
                        color: /*(damageNop == 0) ? */(damageConditionCode.isEmpty) ? (uldDamageAcceptStatus == "A") ? MyColor.colorGrey.withOpacity(0.3) : MyColor.primaryColorblue : MyColor.colorRed /*: MyColor.colorRed*/,
                        press: () {
                          if(isButtonEnabled("ulddamage", buttonRightsList)){
                            Navigator.pop(context, 1); // Return true when "Ok" is pressed
                          }else{

                            SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                            Vibration.vibrate(duration: 500);
                          }

                        },
                      ),
                    ) ,
                    message.contains('BULK') ? SizedBox() : SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        text: "${lableModel.start}",
                        color: (uldDamageAcceptStatus == "A") ? MyColor.colorGrey.withOpacity(0.3) : MyColor.primaryColorblue,
                        press: () {
                          if(isButtonEnabled("start", buttonRightsList)){
                            Navigator.pop(context, 2); // Return true when "Ok" is pressed
                          }else{
                            SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                            Vibration.vibrate(duration: 500);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        text: "${lableModel.addMail}",
                        color: (uldDamageAcceptStatus == "A") ? MyColor.colorGrey.withOpacity(0.3) : MyColor.primaryColorblue,
                        press: () {

                          if(isButtonEnabled("addmail", buttonRightsList)){
                            Navigator.pop(context, 3); // Return true when "Ok" is pressed
                          }else{

                            SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                            Vibration.vibrate(duration: 500);
                          }

                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                    Expanded(
                      flex: 1,
                      child: RoundedButtonBlue(
                        isborderButton: true,
                        text: "${lableModel.cancel}",
                        color: (uldDamageAcceptStatus == "A") ? MyColor.colorGrey.withOpacity(0.3) : MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


  static Future<String?> showPriorityChangeBottomULDDialog(BuildContext context, String uldNo, String priority, LableModel lableModel, ui.TextDirection textDirection) {

    print("CHECK_ULD NO === ${uldNo}");
    TextEditingController priorityController = TextEditingController();
    FocusNode priorityFocusNode = FocusNode();
    priorityController.text = priority;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,  // Ensures the bottom sheet adjusts when the keyboard is opened
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(priorityFocusNode);
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,  // Adjust for keyboard
          ),
          child: FractionallySizedBox(
            widthFactor: 1,  // Adjust the width to 90% of the screen width
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(text: "${lableModel.changePriority}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                            },
                            child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                      ],
                    ),
                  ),
                  CustomDivider(
                    space: 0,
                    color: MyColor.textColorGrey,
                    hascolor: true,
                    thickness: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 6),
                    child: Row(
                      children: [
                        SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal,
                        ),
                        CustomeText(
                            text: (uldNo.replaceAll(" ", "").trim().isEmpty) ? "Changing priority of BULK" : "${lableModel.changePriorityMSG} ${uldNo}" ,
                            fontColor: MyColor.textColorGrey2,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start)
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                    child: CustomTextField(
                      focusNode: priorityFocusNode,
                      textDirection: textDirection,
                      hasIcon: false,
                      hastextcolor: true,
                      animatedLabel: true,
                      needOutlineBorder: true,
                      labelText: "${lableModel.priority}",
                      readOnly: false,
                      controller: priorityController,
                      maxLength: 2,
                      onChanged: (value, validate) {},
                      fillColor: Colors.grey.shade100,
                      textInputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      hintTextcolor: Colors.black,
                      verticalPadding: 0,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                      circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                      boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                      digitsOnly: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill out this field";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  CustomDivider(
                    space: 0,
                    color: MyColor.textColorGrey,
                    hascolor: true,
                    thickness: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RoundedButtonBlue(
                            text: "${lableModel.cancel}",
                            isborderButton: true,
                            press: () {
                              Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: RoundedButtonBlue(
                            text: "${lableModel.save}",
                            press: () {
                              Navigator.pop(context, priorityController.text);  // Return the text when "Save" is pressed
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  static Future<String?> showPriorityChangeBottomAWBDialog(BuildContext context, String awbNo, String priority, LableModel lableModel, ui.TextDirection textDirection) {
    TextEditingController priorityController = TextEditingController();
    FocusNode priorityFocusNode = FocusNode();
    priorityController.text = priority;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,  // Ensures the bottom sheet adjusts when the keyboard is opened
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(priorityFocusNode);
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,  // Adjust for keyboard
          ),
          child: FractionallySizedBox(
            widthFactor: 1,  // Adjust the width to 90% of the screen width
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(text: "${lableModel.changePriority}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                            },
                            child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                      ],
                    ),
                  ),
                  CustomDivider(
                    space: 0,
                    color: MyColor.textColorGrey,
                    hascolor: true,
                    thickness: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 6),
                    child: Row(
                      children: [
                        SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal,
                        ),
                        Flexible(
                          child: CustomeText(
                              text: "${lableModel.priorityAWbMsg} ${AwbFormateNumberUtils.formatAWBNumber(awbNo)}",
                              fontColor: MyColor.textColorGrey2,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                    child: CustomTextField(
                      focusNode: priorityFocusNode,
                      textDirection: textDirection,
                      hasIcon: false,
                      hastextcolor: true,
                      animatedLabel: true,
                      needOutlineBorder: true,
                      labelText: "${lableModel.priority}",
                      readOnly: false,
                      controller: priorityController,
                      maxLength: 2,
                      onChanged: (value, validate) {},
                      fillColor: Colors.grey.shade100,
                      textInputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      hintTextcolor: Colors.black,
                      verticalPadding: 0,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                      circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                      boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                      digitsOnly: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill out this field";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  CustomDivider(
                    space: 0,
                    color: MyColor.textColorGrey,
                    hascolor: true,
                    thickness: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RoundedButtonBlue(
                            text: "${lableModel.cancel}",
                            isborderButton: true,
                            press: () {
                              Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: RoundedButtonBlue(
                            text: "${lableModel.save}",
                            press: () {
                              Navigator.pop(context, priorityController.text);  // Return the text when "Save" is pressed
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<Map<String, String>?> showULDAcceptanceDialog(BuildContext context, String uldNo, LableModel lableModel, ui.TextDirection textDirection, String isGroupIdIsMandatory, String location, int userIdentity, int companyCode, int menuId, String refrelCode, String title, List<ButtonRight> buttonRightsList) {
    TextEditingController uldOwnerController = TextEditingController();
    TextEditingController groupIdController = TextEditingController();
    FocusNode groupIdFocusNode = FocusNode();
    FocusNode uldOwnerFocusNode = FocusNode();
    String errorText = "";
    String _isdamageOrNot = "";

    uldOwnerController.text = uldNo;
    bool isFocusSet = false;

    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {

              if (!isFocusSet) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusScope.of(context).requestFocus(groupIdFocusNode);
                });
                isFocusSet = true;
              }


              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
                ),
                child: FractionallySizedBox(
                  widthFactor: 1,  // Adjust the width to 90% of the screen width
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeVertical * 2,
                        horizontal: SizeConfig.blockSizeHorizontal * 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context, null);
                                  },
                                  child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          CustomDivider(
                            space: 0,
                            color: Colors.black,
                            hascolor: true,
                            thickness: 2,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          Row(
                            children: [
                              SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                              SizedBox(width: SizeConfig.blockSizeHorizontal,),
                              CustomeText(
                                text: "${lableModel.enteringDetailForULD} ${uldNo}",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),

                          GroupIdCustomTextField(
                            textDirection: textDirection,
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            focusNode: uldOwnerFocusNode,
                            labelText: "${lableModel.uldNo} *",
                            readOnly: true,
                            controller: uldOwnerController,
                            onChanged: (value) {
                              setState(() {
                                errorText = "";
                              });
                            },
                            fillColor: MyColor.textColorGrey2,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black,
                            verticalPadding: 0,
                            maxLength: 3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill out this field";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                          GroupIdCustomTextField(
                            textDirection: textDirection,
                            controller: groupIdController,
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            focusNode: groupIdFocusNode,
                            labelText: (isGroupIdIsMandatory == "Y")
                                ? "${lableModel.groupId} *"
                                : "${lableModel.groupId}",
                            onChanged: (value) {
                              setState(() {
                                errorText = "";
                              });
                            },
                            fillColor: Colors.grey.shade100,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: MyColor.colorGrey,
                            verticalPadding: 0,
                            maxLength: 15,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill out this field";
                              } else {
                                return null;
                              }
                            },
                          ),
                          if (errorText.isNotEmpty)  // Show error text if not empty
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: CustomeText(
                                text: errorText,
                                fontColor: MyColor.colorRed,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                          CustomDivider(
                            space: 0,
                            color: Colors.black,
                            hascolor: true,
                            thickness: 2,
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                          Row(
                            children: [
                              (uldNo == "BULK") ? const SizedBox() : Expanded(
                                flex: 1,
                                child: RoundedButtonBlue(
                                  text: "${lableModel.uldDamageAccept}",
                                  press: () async {



                                    if(isButtonEnabled("uldDamageAccept", buttonRightsList)){
                                      CommonUtils.ULDGROUPID = groupIdController.text;
                                      if(isGroupIdIsMandatory == "Y"){
                                        if(groupIdController.text.isNotEmpty){


                                          Navigator.pop(context, {
                                            "status": "N",
                                            "groupId": groupIdController.text,
                                            "uldNo": uldOwnerController.text,
                                          });

                                        }else{
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          setState(() {
                                            errorText = lableModel.enterGropIdMsg!;
                                          });
                                        }
                                      }
                                      else{
                                        Navigator.pop(context, {
                                          "status": "N",
                                          "groupId": groupIdController.text,
                                          "uldNo": uldOwnerController.text,
                                        });
                                      }
                                    }
                                    else{
                                      setState(() {
                                        errorText = ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg;
                                      });
                                     // SnackbarUtil.showSnackbar(context, "You don't have sufficient rights", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      Vibration.vibrate(duration: 500);
                                    }


                                  },
                                ),
                              ),
                              (uldNo == "BULK") ? const SizedBox() : const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: RoundedButtonBlue(
                                  text: "${lableModel.accept}",
                                  press: () {

                                    print("CHECKING======= ${isButtonEnabled("accept", buttonRightsList)}");

                                    if(isButtonEnabled("accept", buttonRightsList)){
                                      CommonUtils.ULDGROUPID = groupIdController.text;
                                      if(isGroupIdIsMandatory == "Y"){
                                        if(groupIdController.text.isNotEmpty){
                                          Navigator.pop(context, {
                                            "status": "Y",
                                            "groupId": groupIdController.text,
                                            "uldNo": uldOwnerController.text
                                          });
                                        }else{
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          setState(() {
                                            errorText = lableModel.enterGropIdMsg!;
                                          });
                                        }
                                      }
                                      else{
                                        Navigator.pop(context, {
                                          "status": "Y",
                                          "groupId": groupIdController.text,
                                          "uldNo": uldOwnerController.text
                                        });
                                      }
                                    }else{
                                      setState(() {
                                        errorText = ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg;
                                      });
                                     // SnackbarUtil.showSnackbar(context, "You don't have sufficient rights", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      Vibration.vibrate(duration: 500);
                                    }



                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical),
                          RoundedButtonBlue(
                            isborderButton: true,
                            text: "${lableModel.cancel}",
                            press: () {
                              Navigator.pop(newContext, null);  // Return null when "Cancel" is pressed
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  static Future<Map<String, String>?> showUCRBottomULDDialog(BuildContext context, String uldNo, LableModel lableModel, ui.TextDirection textDirection, String isGroupIdIsMandatory, String location, int userIdentity, int companyCode, int menuId, String title,  List<ButtonRight> buttonRightsList) {
    TextEditingController ucrNumberController = TextEditingController();
    TextEditingController uldOwnerController = TextEditingController();
    TextEditingController groupIdController = TextEditingController();
    FocusNode ucrFocusNode = FocusNode();
    FocusNode groupIdFocusNode = FocusNode();
    FocusNode uldOwnerFocusNode = FocusNode();
    String errorText = "";

    String ULDNumber = uldNo.replaceAll(" ", "");
    List<String> uldParts = uldNo.split(' ');
    bool isFocusSet = false;



    // Assign the parts to meaningful variables
    String uldType = uldParts[0];   // Third part (ULD owner)
    String uldn = uldParts[1];   // Third part (ULD owner)
    String uldOwner = uldParts[2];   // Third part (ULD owner)

    uldOwnerController.text = uldOwner;




    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {



        return StatefulBuilder(
          builder:(BuildContext context, StateSetter setState) {
            // Only set focus once after the widget is built
            if (!isFocusSet) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusScope.of(context).requestFocus(ucrFocusNode);
              });
              isFocusSet = true;
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
              ),
              child: FractionallySizedBox(
                widthFactor: 1,  // Adjust the width to 90% of the screen width
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 2,
                      horizontal: SizeConfig.blockSizeHorizontal * 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                            InkWell(
                                onTap: () {
                                  /*Navigator.pop(context, null);*/
                                  Navigator.pop(context, {
                                    "status": "N",
                                  });
                                },
                                child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),
                        CustomDivider(
                          space: 0,
                          color: Colors.black,
                          hascolor: true,
                          thickness: 1,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),
                        Row(
                          children: [
                            SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                            SizedBox(width: SizeConfig.blockSizeHorizontal,),
                            CustomeText(
                              text: "${lableModel.enteringDetailForULD} ${uldNo}",
                              fontColor: MyColor.textColorGrey2,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),

                        GroupIdCustomTextField(
                          focusNode: ucrFocusNode,
                          textDirection: textDirection,
                          hasIcon: false,
                          hastextcolor: true,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: "${lableModel.ucr}",
                          readOnly: false,
                          controller: ucrNumberController,
                          onChanged: (value) {},
                          fillColor: Colors.grey.shade100,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          hintTextcolor: Colors.black,
                          verticalPadding: 0,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                          circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                          boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please fill out this field";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                        GroupIdCustomTextField(
                          textDirection: textDirection,
                          hasIcon: false,
                          hastextcolor: true,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          focusNode: uldOwnerFocusNode,
                          labelText: "${lableModel.uldOwner} *",
                          readOnly: false,
                          controller: uldOwnerController,
                          onChanged: (value) {
                            setState(() {
                              errorText = "";
                            });
                          },
                          fillColor: Colors.grey.shade100,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          hintTextcolor: Colors.black,
                          verticalPadding: 0,
                          maxLength: 3,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                          circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                          boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please fill out this field";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                        GroupIdCustomTextField(
                          textDirection: textDirection,
                          controller: groupIdController,
                          hasIcon: false,
                          hastextcolor: true,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          focusNode: groupIdFocusNode,
                          labelText: (isGroupIdIsMandatory == "Y")
                              ? "${lableModel.groupId} *"
                              : "${lableModel.groupId}",
                          onChanged: (value) {
                            setState(() {
                              errorText = "";
                            });
                          },
                          fillColor: Colors.grey.shade100,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          hintTextcolor: MyColor.colorGrey,
                          verticalPadding: 0,
                          maxLength: 15,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                          circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                          boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please fill out this field";
                            } else {
                              return null;
                            }
                          },
                        ),
                        if (errorText.isNotEmpty)  // Show error text if not empty
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: CustomeText(
                              text: errorText,
                              fontColor: MyColor.colorRed,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                        CustomDivider(
                          space: 0,
                          color: Colors.black,
                          hascolor: true,
                          thickness: 1,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RoundedButtonBlue(
                                text: "${lableModel.uldDamageAccept}",
                                press: () {

                                  if(isButtonEnabled("uldDamageAccept", buttonRightsList)){
                                    if(uldOwnerController.text.isNotEmpty){
                                      if(isGroupIdIsMandatory == "Y"){
                                        if(groupIdController.text.isNotEmpty){
                                          CommonUtils.UCRBTSTATUS = "D";
                                          CommonUtils.UCRGROUPID = groupIdController.text;
                                          context.read<UldAcceptanceCubit>().uldUCR(ucrNumberController.text, ULDNumber, uldOwnerController.text, location, groupIdController.text, userIdentity, companyCode, menuId);
                                        }else{
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          setState(() {
                                            errorText = lableModel.enterGropIdMsg!;
                                          });
                                        }
                                      }else{
                                        context.read<UldAcceptanceCubit>().uldUCR(ucrNumberController.text, ULDNumber,uldOwnerController.text, location, groupIdController.text, userIdentity, companyCode, menuId);
                                      }
                                    }
                                    else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(uldOwnerFocusNode);
                                      });
                                      setState(() {
                                        errorText = lableModel.enteruldOwnerMsg!;
                                      });
                                    }
                                  }else{
                                    setState(() {
                                      errorText = ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg;
                                    });
                                  //  SnackbarUtil.showSnackbar(context, "You don't have sufficient rights", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }






                                  // Return both UCR and Group ID
                                  /*Navigator.pop(newContext, ucrNumberController.text); */// Return the text when "Save" is pressed
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: RoundedButtonBlue(
                                text: "${lableModel.accept}",
                                press: () {

                                  if(isButtonEnabled("accept", buttonRightsList)){
                                    if(uldOwnerController.text.isNotEmpty){
                                      if(isGroupIdIsMandatory == "Y"){
                                        if(groupIdController.text.isNotEmpty){
                                          CommonUtils.UCRBTSTATUS = "A";
                                          context.read<UldAcceptanceCubit>().uldUCR(ucrNumberController.text, ULDNumber, uldOwnerController.text, location, groupIdController.text, userIdentity, companyCode, menuId);
                                        }else{
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          setState(() {
                                            errorText = lableModel.enterGropIdMsg!;
                                          });
                                        }
                                      }
                                      else{
                                        context.read<UldAcceptanceCubit>().uldUCR(ucrNumberController.text, ULDNumber, uldOwnerController.text, location, groupIdController.text, userIdentity, companyCode, menuId);
                                      }
                                    }
                                    else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(uldOwnerFocusNode);
                                      });
                                      setState(() {
                                        errorText = lableModel.enteruldOwnerMsg!;
                                      });
                                    }
                                  }else{
                                    setState(() {
                                      errorText = ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg;
                                    });
                                    //SnackbarUtil.showSnackbar(context, "You don't have sufficient rights", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }



                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical),
                        RoundedButtonBlue(
                          isborderButton: true,
                          text: "${lableModel.cancel}",
                          press: () {
                            Navigator.pop(context, {
                              "status": "N",
                            });  // Return null when "Cancel" is pressed
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  static Future<bool?> showULDNotExit(BuildContext context, LableModel lableModel, String uldTitleMsg) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${uldTitleMsg}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${lableModel.emptyULDMessage}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )


          ],
        );
      },
    );
  }

  static bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
    ButtonRight? button = buttonList.firstWhere(
          (button) => button.buttonId == buttonId,
    );
    return button.isEnable == 'Y';
  }

  static Future<bool?> confirmationDialog(BuildContext context, LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "${lableModel.lastBTConfirm}",fontSize: SizeConfig.textMultiplier * 2.1, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${lableModel.lastBTMsg}",fontSize: SizeConfig.textMultiplier * 1.8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  static Future<bool?> showULDDamageDialog(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.done, color: MyColor.colorGreen, size: SizeConfig.blockSizeVertical * 10),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              CustomeText(
                text: message,
                fontColor: MyColor.colorBlack,
                fontSize: SizeConfig.textMultiplier * 2.2,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              RoundedButtonBlue(
                text: "Ok",
                color: MyColor.primaryColorblue,
                press: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<Map<String, String>?> showFoundCargoAWBDialog(
      BuildContext context,
      String awbNo,
      LableModel lableModel, ui.TextDirection textDirection,
      int userIdentity, int companyCode,
      int menuId,
      String title,
      List<ButtonRight> buttonRightsList,
      String groupIdRequired,
      int groupIDCharSize,
      int flightSeqNo,
      int uldSeqNo,
      String locationCode) {

    TextEditingController piecesController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    TextEditingController originController = TextEditingController();
    TextEditingController destinationController = TextEditingController();

    TextEditingController groupIdController = TextEditingController();
    FocusNode piecesFocusNode = FocusNode();
    FocusNode weightFocusNode = FocusNode();
    FocusNode originFocusNode = FocusNode();
    FocusNode destinationFocusNode = FocusNode();
    FocusNode groupIdFocusNode = FocusNode();
    String errorText = "";
    String btnClick = "";

    bool _isvalidateOrigin = false;
    bool _isvalidateDestination = false;



    Future<void> leaveOriginFocus() async {
      if (originController.text.isNotEmpty) {
        // call check airport api
        context.read<FlightCheckCubit>().checkOAirportCity(originController.text, userIdentity, companyCode, menuId);
      }
    }

    Future<void> leaveDestinationFocus() async {
      if (destinationController.text.isNotEmpty) {
        // call check airport api

        if(originController.text == destinationController.text){
          destinationController.clear();
        }else{
          context.read<FlightCheckCubit>().checkDAirportCity(destinationController.text, userIdentity, companyCode, menuId);
        }


      }
    }



    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {

        originFocusNode.addListener(() {
          if (!originFocusNode.hasFocus) {
            leaveOriginFocus();
          }
        });

        destinationFocusNode.addListener(() {
          if (!destinationFocusNode.hasFocus) {
            leaveDestinationFocus();
          }
        },);




        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {

              return WillPopScope(
                onWillPop: () async{
                  piecesController.clear();
                  weightController.clear();
                  originController.clear();
                  destinationController.clear();
                  groupIdController.clear();
                  _isvalidateOrigin = false;
                  _isvalidateDestination = false;


                  Navigator.pop(context, {
                    "status": "N",
                  });
                  return true; // Allow the modal to close
                },
                child: BlocListener<FlightCheckCubit, FlightCheckState>(listener: (context, state) {
                  if (state is MainInitialState) {
                  }
                  else if (state is MainLoadingState) {
                    // showing loading dialog in this state
                    DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                  }
                  else if (state is CheckOAirportCitySuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.airportCityModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                     // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.airportCityModel.statusMessage!;
                        _isvalidateOrigin = false;
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(originFocusNode);
                      },
                      );

                    }else{
                      _isvalidateOrigin = true;
                      setState(() {
                        errorText = "";
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(destinationFocusNode);
                      },
                      );
                    }
                  }
                  else if (state is CheckOAirportCityFailureState){
                    DialogUtils.hideLoadingDialog(context);
                    Vibration.vibrate(duration: 500);
                   // SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                    setState(() {
                      errorText = state.error;
                      _isvalidateOrigin = false;
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      FocusScope.of(context).requestFocus(originFocusNode);
                    },
                    );
                  }
                  else if (state is CheckDAirportCitySuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.airportCityModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                     // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.airportCityModel.statusMessage!;
                        _isvalidateDestination = false;
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(destinationFocusNode);
                      },
                      );

                    }else{
                      _isvalidateDestination = true;
                      setState(() {
                        errorText = "";
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(groupIdFocusNode);
                      },
                      );
                    }
                  }
                  else if (state is CheckDAirportCityFailureState){
                    DialogUtils.hideLoadingDialog(context);
                    Vibration.vibrate(duration: 500);
                    //SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                    setState(() {
                      errorText = state.error;
                      _isvalidateDestination = false;
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      FocusScope.of(context).requestFocus(destinationFocusNode);
                    },
                    );
                  }
                  else if (state is AddFoundCargoSuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.foundCargoSaveModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                      // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.foundCargoSaveModel.statusMessage!;
                      });
                    }else{

                      if(btnClick == "D"){
                        Navigator.pop(context, {
                          "status": "D",
                          "pieces" : piecesController.text,
                          "weight" : weightController.text,
                          "iMPAWBRowId" : "${state.foundCargoSaveModel.iMPAWBRowId}",
                          "iMShipRowId" : "${state.foundCargoSaveModel.iMShipRowId}",
                          "groupId" : groupIdController.text
                        });
                      }else if(btnClick == "A"){
                        Navigator.pop(context, {
                          "status": "A",
                        });
                      }

                    }
                  }
                  else if (state is AddFoundCargoFailureState){
                    Vibration.vibrate(duration: 500);
                    // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                    setState(() {
                      errorText = state.error;
                    });
                  }

                },

                child:Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1,  // Adjust the width to 90% of the screen width
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 2,
                          horizontal: SizeConfig.blockSizeHorizontal * 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                InkWell(
                                    onTap: () {
                                      /*Navigator.pop(context, null);*/

                                      piecesController.clear();
                                      weightController.clear();
                                      originController.clear();
                                      destinationController.clear();
                                      groupIdController.clear();
                                      _isvalidateOrigin = false;
                                      _isvalidateDestination = false;


                                      Navigator.pop(context, {
                                        "status": "N",
                                      });
                                    },
                                    child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            CustomDivider(
                              space: 0,
                              color: Colors.black,
                              hascolor: true,
                              thickness: 1,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Row(
                              children: [
                                SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                CustomeText(
                                  text: "${lableModel.detailsForAWBNo} ${AwbFormateNumberUtils.formatAWBNumber(awbNo)}",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),

                            Row(
                              children: [
                                Expanded(
                                  flex:1,
                                  child: Directionality(
                                    textDirection: textDirection,
                                    child: CustomTextField(
                                      textDirection: textDirection,
                                      controller: piecesController,
                                      focusNode: piecesFocusNode,
                                      onPress: () {},
                                      hasIcon: false,
                                      hastextcolor: true,
                                      animatedLabel: true,
                                      needOutlineBorder: true,
                                      labelText: "${lableModel.pieces} *",
                                      readOnly: false,
                                      maxLength: 3,
                                      onChanged: (value) {
                                        setState(() {
                                          errorText = "";
                                        });
                                      },
                                      fillColor:  Colors.grey.shade100,
                                      textInputType: TextInputType.number,
                                      inputAction: TextInputAction.next,
                                      hintTextcolor: Colors.black45,
                                      verticalPadding: 0,
                                      digitsOnly: true,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                      circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                      boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please fill out this field";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                Expanded(
                                  flex:1,
                                  child: Directionality(
                                    textDirection: textDirection,
                                    child: CustomTextField(
                                      textDirection: textDirection,
                                      controller: weightController,
                                      focusNode: weightFocusNode,
                                      onPress: () {},
                                      hasIcon: false,
                                      hastextcolor: true,
                                      animatedLabel: true,
                                      needOutlineBorder: true,
                                      labelText: "${lableModel.weight}",
                                      readOnly: false,
                                      maxLength: 10,
                                      digitsOnly: false,
                                      doubleDigitOnly: true,
                                      onChanged: (value) {
                                        setState(() {
                                          weightController.text = "${CommonUtils.formateToTwoDecimalPlacesValue(value)}";
                                          // weightCount = double.parse(CommonUtils.formateToTwoDecimalPlacesValue(value));
                                        });

                                      },
                                      fillColor:  Colors.grey.shade100,
                                      textInputType: TextInputType.number,
                                      inputAction: TextInputAction.next,
                                      hintTextcolor: Colors.black45,
                                      verticalPadding: 0,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                      circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                      boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please fill out this field";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                            Row(
                              children: [
                                Expanded(
                                  flex:1,
                                  child: CustomeEditTextWithBorder(
                                    lablekey: "AIRPORT",
                                    controller: originController,
                                    focusNode: originFocusNode,
                                    onPress: () {},
                                    hasIcon: false,
                                    hastextcolor: true,
                                    animatedLabel: true,
                                    needOutlineBorder: true,
                                    labelText: "${lableModel.origin} *",
                                    readOnly: false,
                                    maxLength: 3,
                                    isShowSuffixIcon: _isvalidateOrigin,
                                    onChanged: (value, validate) {
                                      destinationController.clear();
                                      _isvalidateDestination = false;
                                      setState(() {
                                        _isvalidateOrigin = false;
                                        errorText = "";
                                      });
                                      if (value.toString().isEmpty) {
                                        destinationController.clear();
                                        _isvalidateDestination = false;
                                        _isvalidateOrigin = false;
                                        setState(() {
                                          errorText = "";
                                        });
                                      }
                                    },
                                    fillColor:  Colors.grey.shade100,
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    hintTextcolor: Colors.black45,
                                    verticalPadding: 0,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                    circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                    boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please fill out this field";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                Expanded(
                                  flex: 1,
                                  child: CustomeEditTextWithBorder(
                                    lablekey: "AIRPORT",
                                    controller: destinationController,
                                    focusNode: destinationFocusNode,
                                    onPress: () {},
                                    hasIcon: false,
                                    hastextcolor: true,
                                    animatedLabel: true,
                                    needOutlineBorder: true,
                                    labelText: "${lableModel.destination} *",
                                    readOnly: false,
                                    maxLength: 3,
                                    isShowSuffixIcon: _isvalidateDestination,
                                    onChanged: (value, validate) {

                                      setState(() {
                                        _isvalidateDestination = false;
                                        errorText = "";
                                      });


                                      if (value.isEmpty) {
                                        setState(() {
                                          _isvalidateDestination = false;
                                          errorText = "";

                                        });
                                        return;
                                      }

                                      // Check if the destination matches the origin
                                      if (destinationController.text.isNotEmpty && originController.text == value) {
                                        setState(() {
                                          _isvalidateDestination = false;
                                          errorText = "${lableModel.originDestinationSameMsg}"; // Show error message
                                          Vibration.vibrate(duration: 500);
                                        });
                                        return;
                                      }

                                    },
                                    fillColor:  Colors.grey.shade100,
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    hintTextcolor: Colors.black45,
                                    verticalPadding: 0,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                    circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                    boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please fill out this field";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                            // text manifest and recived in pices text counter
                            Directionality(
                              textDirection: textDirection,
                              child: CustomTextField(
                                textDirection: textDirection,
                                controller: groupIdController,
                                focusNode: groupIdFocusNode,
                                onPress: () {},
                                hasIcon: false,
                                hastextcolor: true,
                                animatedLabel: true,
                                needOutlineBorder: true,
                                labelText: groupIdRequired == "Y" ? "${lableModel.groupId} *" : "${lableModel.groupId}",
                                readOnly: false,
                                maxLength: (groupIDCharSize == 0) ? 1 : groupIDCharSize,
                                onChanged: (value) {
                                  if(groupIdController.text.isEmpty){
                                    setState(() {
                                      errorText = "";
                                    });
                                  }

                                },
                                fillColor: Colors.grey.shade100,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                hintTextcolor: Colors.black45,
                                verticalPadding: 0,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill out this field";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            (errorText.isNotEmpty) ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                            if (errorText.isNotEmpty)  // Show error text if not empty
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CustomeText(
                                  text: errorText,
                                  fontColor: MyColor.colorRed,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            CustomDivider(
                              space: 0,
                              color: Colors.black,
                              hascolor: true,
                              thickness: 1,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RoundedButtonBlue(
                                    isborderButton: true,
                                    text: "${lableModel.damage}",
                                    press: () {

                                      btnClick = "D";

                                      if (piecesController.text.isEmpty) {

                                        setState(() {
                                          errorText = "${lableModel.piecesMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(piecesFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if (weightController.text.isEmpty) {
                                        setState(() {
                                          errorText = "${lableModel.weightMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(weightFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if(int.parse(piecesController.text) == 0){
                                        setState(() {
                                          errorText = "${lableModel.enterPiecesGrtMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(piecesFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if(double.parse(weightController.text) == 0){
                                        setState(() {
                                          errorText = "${lableModel.enterWeightGrtMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(weightFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);
                                        return;
                                      }

                                      if (originController.text.isEmpty || !_isvalidateOrigin) {
                                        setState(() {
                                          errorText = "${lableModel.originMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(originFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);
                                        return;
                                      }

                                      if (destinationController.text.isEmpty || !_isvalidateDestination) {
                                        setState(() {
                                          errorText = "${lableModel.destinationMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(destinationFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);
                                        return;
                                      }

                                      if(groupIdRequired == "Y"){
                                        if (groupIdController.text.isEmpty) {
                                          setState(() {
                                            errorText = "${lableModel.enterGropIdMsg}";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }
                                        // Check if the groupId length is between 14 (min and max 14 characters)
                                        if (groupIdController.text.length != groupIDCharSize) {
                                          setState(() {
                                            errorText = formatMessage("${lableModel.groupIdCharSizeMsg}", ["${groupIDCharSize}"]);
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }

                                      }


                                      context.read<FlightCheckCubit>().addFoundCargoSave(
                                          flightSeqNo,
                                          uldSeqNo,
                                          awbNo,
                                          int.parse(piecesController.text),
                                          double.parse(weightController.text),
                                          groupIdController.text,
                                          locationCode,
                                          originController.text,
                                          destinationController.text,
                                          userIdentity,
                                          companyCode,
                                          menuId
                                      );



                                      /* Navigator.pop(context, {
                                        "status": "N",
                                      });*/
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: RoundedButtonBlue(
                                    text: "${lableModel.accept}",
                                    press: () {

                                      btnClick = "A";

                                      if (piecesController.text.isEmpty) {

                                        setState(() {
                                          errorText = "${lableModel.piecesMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(piecesFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if (weightController.text.isEmpty) {
                                        setState(() {
                                          errorText = "${lableModel.weightMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(weightFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if(int.parse(piecesController.text) == 0){
                                        setState(() {
                                          errorText = "${lableModel.enterPiecesGrtMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(piecesFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if(double.parse(weightController.text) == 0){
                                        setState(() {
                                          errorText = "${lableModel.enterWeightGrtMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(weightFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);
                                        return;
                                      }

                                      if (originController.text.isEmpty || !_isvalidateOrigin) {
                                        setState(() {
                                          errorText = "${lableModel.originMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(originFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);
                                        return;
                                      }

                                      if (destinationController.text.isEmpty || !_isvalidateDestination) {
                                        setState(() {
                                          errorText = "${lableModel.destinationMsg}";
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(destinationFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);
                                        return;
                                      }

                                      if(groupIdRequired == "Y"){
                                        if (groupIdController.text.isEmpty) {
                                          setState(() {
                                            errorText = "${lableModel.enterGropIdMsg}";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }
                                        // Check if the groupId length is between 14 (min and max 14 characters)
                                        if (groupIdController.text.length != groupIDCharSize) {
                                          setState(() {
                                            errorText = formatMessage("${lableModel.groupIdCharSizeMsg}", ["${groupIDCharSize}"]);
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(groupIdFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }

                                      }


                                      context.read<FlightCheckCubit>().addFoundCargoSave(
                                        flightSeqNo,
                                        uldSeqNo,
                                        awbNo,
                                        int.parse(piecesController.text),
                                        double.parse(weightController.text),
                                        groupIdController.text,
                                        locationCode,
                                        originController.text,
                                        destinationController.text,
                                        userIdentity,
                                        companyCode,
                                        menuId
                                      );



                                    },
                                  ),
                                ),
                              ],
                            ),



                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ),
              );

            }
        );
      },
    );
  }

  static Future<String?> showBatteryChangeBottomULDDialog(BuildContext context, String uldNo, String battery, LableModel lableModel, ui.TextDirection textDirection) {
    TextEditingController batteryController = TextEditingController();
    FocusNode batteryFocusNode = FocusNode();
    if(battery == "-1"){
      batteryController.clear();
    }else{
      batteryController.text = battery;
    }


    String errorText = "";

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,  // Ensures the bottom sheet adjusts when the keyboard is opened
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(batteryFocusNode);
        });

        return StatefulBuilder(
          builder:(BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,  // Adjust for keyboard
            ),
            child: FractionallySizedBox(
              widthFactor: 1,  // Adjust the width to 90% of the screen width
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomeText(text: "${lableModel.changeBattery}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                              },
                              child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                        ],
                      ),
                    ),
                    CustomDivider(
                      space: 0,
                      color: MyColor.textColorGrey,
                      hascolor: true,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 6),
                      child: Row(
                        children: [
                          SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal,
                          ),
                          CustomeText(
                              //text: "Change battery for this ${uldNo}",
                              text : CommonUtils.formatMessage("${lableModel.chanebetteryforthis}", [uldNo]),
                              fontColor: MyColor.textColorGrey2,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start)
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                      child: CustomTextField(
                        focusNode: batteryFocusNode,
                        textDirection: textDirection,
                        hasIcon: false,
                        hastextcolor: true,
                        animatedLabel: true,
                        needOutlineBorder: true,
                        labelText: "${lableModel.battery}",
                        readOnly: false,
                        controller: batteryController,
                        maxLength: 3,
                        onChanged: (value, validate) {
                          if(batteryController.text.isEmpty){
                            setState(() {
                              errorText = "";
                            });
                          }

                        },
                        fillColor: Colors.grey.shade100,
                        textInputType: TextInputType.number,
                        inputAction: TextInputAction.next,
                        hintTextcolor: Colors.black,
                        verticalPadding: 0,
                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                        circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                        boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                        digitsOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please fill out this field";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    if (errorText.isNotEmpty)  // Show error text if not empty
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 8),
                        child: CustomeText(
                          text: errorText,
                          fontColor: MyColor.colorRed,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                    CustomDivider(
                      space: 0,
                      color: MyColor.textColorGrey,
                      hascolor: true,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: RoundedButtonBlue(
                              text: "${lableModel.cancel}",
                              isborderButton: true,
                              press: () {
                                Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: RoundedButtonBlue(
                              text: "${lableModel.save}",
                              press: () {

                                int? batteryValue = int.tryParse(batteryController.text);

                                if (batteryController.text.isEmpty) {
                                  setState(() {
                                    errorText = "${lableModel.betterymsg}";
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(batteryFocusNode);
                                  });
                                  Vibration.vibrate(duration: 500);
                                  return;
                                }

                                if (batteryValue! < 0 || batteryValue > 100) {
                                  setState(() {
                                    errorText = "${lableModel.betteryminimummsg}";
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(batteryFocusNode);
                                  });
                                  Vibration.vibrate(duration: 500);
                                  return;
                                }

                                Navigator.pop(context, batteryController.text);  // Return the text when "Save" is pressed
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },);




      },
    );
  }

  static Future<Map<String, String>?> showTempretureChangeBottomULDDialog(BuildContext context, String uldNo, String temp, String tempUnit, LableModel lableModel, ui.TextDirection textDirection) {
    TextEditingController tempretureController = TextEditingController();
    FocusNode tempretureFocusNode = FocusNode();
    tempretureController.text = temp;
    String tUnit = (tempUnit.isEmpty) ? "C" : tempUnit;
    String errorText = "";

    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,  // Ensures the bottom sheet adjusts when the keyboard is opened
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(tempretureFocusNode);
        });

        return StatefulBuilder(
          builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,  // Adjust for keyboard
            ),
            child: FractionallySizedBox(
              widthFactor: 1,  // Adjust the width to 90% of the screen width
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomeText(text: "${lableModel.changeTemperature}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                              },
                              child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                        ],
                      ),
                    ),
                    CustomDivider(
                      space: 0,
                      color: MyColor.textColorGrey,
                      hascolor: true,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 6),
                      child: Row(
                        children: [
                          SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal,
                          ),
                          CustomeText(
                             // text: "Change temperature for this ${uldNo}",
                              text : CommonUtils.formatMessage("${lableModel.changeTempforthis}", [uldNo]),
                              fontColor: MyColor.textColorGrey2,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start)
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex:2,
                            child: CustomTextField(
                              focusNode: tempretureFocusNode,
                              textDirection: textDirection,
                              hasIcon: false,
                              hastextcolor: true,
                              animatedLabel: true,
                              needOutlineBorder: true,
                              labelText: "${lableModel.temperature}",
                              readOnly: false,
                              controller: tempretureController,
                              maxLength: 4,
                              onChanged: (value, validate) {
                                setState(() {
                                  errorText = "";
                                });
                              },
                              fillColor: Colors.grey.shade100,
                              textInputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              hintTextcolor: Colors.black,
                              verticalPadding: 0,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                              tempOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this field";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,
                          ),
                          Expanded(
                            flex: 1,
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  // Yes Option
                                  Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap: () {

                                      setState(() {
                                        tUnit = "C";
                                      });

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:  tUnit == "C" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                        ),
                                        padding: EdgeInsets.symmetric(vertical:5, horizontal: 5),
                                        child: Center(
                                            child: CustomeText(text: "C", fontColor:  tUnit == "C" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                        ),
                                      ),
                                    ),
                                  ),

                                  // No Option
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {

                                        setState(() {
                                          tUnit = "F";
                                        });

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: tUnit == "F" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                        ),
                                        padding: EdgeInsets.symmetric(vertical:5, horizontal: 5),
                                        child: Center(
                                            child: CustomeText(text: "F", fontColor: tUnit == "F" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    (errorText.isNotEmpty) ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                    if (errorText.isNotEmpty)  // Show error text if not empty
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomeText(
                          text: errorText,
                          fontColor: MyColor.colorRed,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),

                    CustomDivider(
                      space: 0,
                      color: MyColor.textColorGrey,
                      hascolor: true,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: RoundedButtonBlue(
                              text: "${lableModel.cancel}",
                              isborderButton: true,
                              press: () {
                                Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: RoundedButtonBlue(
                              text: "${lableModel.save}",
                              press: () {
                                int? temperatureValue = int.tryParse(tempretureController.text);
                                if (tempretureController.text.isEmpty) {
                                  setState(() {
                                    errorText = "${lableModel.templevelmsg}";
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(tempretureFocusNode);
                                  });
                                  Vibration.vibrate(duration: 500);
                                  return;
                                }

                                if (temperatureValue == null || temperatureValue < -100 || temperatureValue > 100) {
                                  setState(() {
                                    errorText = "${lableModel.tempminimummsg}";
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(tempretureFocusNode);
                                  });
                                  Vibration.vibrate(duration: 500);
                                  return;
                                }

                                Navigator.pop(context, {
                                  "temp": tempretureController.text,
                                  "tUnit" : tUnit
                                });// Return the text when "Save" is pressed
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },);



      },
    );
  }

  static Future<Map<String, String>?> showAssignFlightDialog(
      BuildContext context,
      int uldSeqNo,
      LableModel lableModel,
      ui.TextDirection textDirection,
      int userIdentity,
      int companyCode,
      int menuId,
      String title,
      String flightNo,
      String flightDate,
      String uldNo) {

    TextEditingController flightNoEditingController = TextEditingController();
    TextEditingController dateEditingController = TextEditingController();

    FocusNode flightNoFocusNode = FocusNode();
    FocusNode dateFocusNode = FocusNode();
    String errorText = "";
    bool _isDatePickerOpen = false;
    DateTime? _selectedDate;



    Future<void> selectDate(BuildContext context, StateSetter setState) async {
      _isDatePickerOpen = true;

      final DateTime now = DateTime.now();
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? now,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );


      if (flightNoEditingController.text.isNotEmpty) {
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
            dateEditingController.text = DateFormat('dd-MMM-yy').format(_selectedDate!).toUpperCase();
          });

        }
        else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(flightNoFocusNode);
          },
          );
        }
      } else {
        setState(() {

          errorText = lableModel.enterFlightNo!;
          WidgetsBinding.instance.addPostFrameCallback(
                (_) {
              FocusScope.of(context).requestFocus(flightNoFocusNode);
            },
          );
        });
      }


      // Ensure the flag is reset even if the dialog is dismissed without selection
      _isDatePickerOpen = false;

      // Manually unfocus to close the keyboard and ensure consistent behavior
      dateFocusNode.unfocus();
    }


    Future<void> selectDate1(BuildContext context, void Function(DateTime?) onDatePicked) async {
      _isDatePickerOpen = true;

      final DateTime now = DateTime.now();
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? now,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      // Pass the picked date to the callback
      onDatePicked(picked);

      // Ensure the flag is reset even if the dialog is dismissed without selection
      _isDatePickerOpen = false;

      // Manually unfocus to close the keyboard and ensure consistent behavior
      dateFocusNode.unfocus();
    }


    dateFocusNode.addListener(() {
      if (dateFocusNode.hasFocus && !_isDatePickerOpen) {
        // Use post frame callback to ensure it is called after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectDate1(context, (pickedDate) {
            if (pickedDate != null) {
              _selectedDate = pickedDate;
              dateEditingController.text = DateFormat('dd-MMM-yy').format(pickedDate).toUpperCase();
            }
            _isDatePickerOpen = false; // Ensure the flag is reset
          });
        });
      }
    });



    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {




        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {





              return WillPopScope(
                onWillPop: () async{
                  flightNoEditingController.clear();
                  dateEditingController.clear();
                  Navigator.pop(context, {
                    "status": "N",
                  });
                  return true; // Allow the modal to close
                },
                child: BlocListener<PalletStackCubit, PalletStackState>(listener: (context, state) {
                  if (state is PalletStackInitialState) {
                  }
                  else if (state is PalletStackLoadingState) {
                    // showing loading dialog in this state
                    DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                  }
                  else if (state is PalletStackAssignFlightSuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.palletStackAssignFlightModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                      // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.palletStackAssignFlightModel.statusMessage!;
                      });
                    }else{

                      Navigator.pop(context, {
                        "status": "D",
                      });

                       SnackbarUtil.showSnackbar(context, state.palletStackAssignFlightModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                    }
                  }
                  else if (state is PalletStackAssignFlightFailureState){
                    Vibration.vibrate(duration: 500);
                    setState(() {
                      errorText = state.error;
                    });
                  }

                },

                  child:Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,  // Adjust the width to 90% of the screen width
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 2,
                            horizontal: SizeConfig.blockSizeHorizontal * 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                  InkWell(
                                      onTap: () {

                                        flightNoEditingController.clear();
                                        dateEditingController.clear();

                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                      child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              Row(
                                children: [
                                  SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                  CustomeText(
                                    text: "Assign flight for this ${uldNo}",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),

                              Row(
                                children: [
                                  Expanded(
                                    flex:1,
                                    child: Directionality(
                                      textDirection: textDirection,
                                      child: CustomeEditTextWithBorder(
                                        lablekey: "FLIGHT",
                                        focusNode: flightNoFocusNode,
                                        nextFocus: dateFocusNode,
                                        textDirection: textDirection,
                                        maxLength: 8,
                                        controller: flightNoEditingController,
                                        hasIcon: false,
                                        hastextcolor: true,
                                        isShowSuffixIcon: flightNoEditingController.text.isEmpty ? false : true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "${lableModel.flightNo} *",
                                        onChanged: (value, validate) {
                                          dateEditingController.clear();
                                          setState(() {
                                            errorText = "";
                                          });
                                        },
                                        readOnly: false,
                                        textInputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        hintTextcolor: MyColor.colorGrey,
                                        verticalPadding: 0,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                        circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                        boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please fill out this field";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  Expanded(
                                    flex:1,
                                    child: Directionality(
                                      textDirection: textDirection,
                                      child: GroupIdCustomTextField(
                                        controller: dateEditingController,
                                        focusNode: dateFocusNode,
                                        onPress: () => !_isDatePickerOpen
                                            ? selectDate(context, setState)
                                            : null,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "${lableModel.flightDate} *",
                                        readOnly: true,
                                        onChanged: (value) {
                                          setState(() {
                                            errorText = "";
                                          });
                                        },
                                        textInputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        hintTextcolor: MyColor.colorGrey,
                                        verticalPadding: 0,
                                        prefixicon: calender,
                                        isShowSuffixIcon: true,
                                        isPassword: false,
                                        hasIcon: true,
                                        isIcon: true,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                        circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                        boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                        iconSize: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please fill out this field";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              (errorText.isNotEmpty) ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              if (errorText.isNotEmpty)  // Show error text if not empty
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomeText(
                                    text: errorText,
                                    fontColor: MyColor.colorRed,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      isborderButton: true,
                                      text: "${lableModel.cancel}",
                                      press: () {
                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "Assign",
                                      press: () {

                                        if (flightNoEditingController.text.isNotEmpty) {
                                          if (dateEditingController.text.isNotEmpty) {

                                           /* Navigator.pop(context, {
                                              "status": "D",
                                            });*/

                                            context.read<PalletStackCubit>().getPalletAssignFlight(uldSeqNo, flightNoEditingController.text, dateEditingController.text, userIdentity, companyCode, menuId,);



                                          } else {

                                            setState(() {
                                              errorText = lableModel.enterFlightDate!;
                                            });

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(dateFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                          }
                                        }
                                        else {

                                          setState(() {
                                            errorText = lableModel.enterFlightNo!;
                                          });

                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(flightNoFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

            }
        );
      },
    );
  }


  static Future<Map<String, String>?> showULDConditionCodeDialog(
      BuildContext context,
      int uldSeqNo,
      LableModel lableModel,
      ui.TextDirection textDirection,
      int userIdentity,
      int companyCode,
      int menuId,
      String title,
      String uldNo,
      List<ULDConditionCodeList> uldConditionCodeList) {

    String errorText = "";

    String conditionName= 'Select';
    String conditionType = '';

    List<ULDConditionCodeList> conditionList = [];

    conditionList.add(ULDConditionCodeList(referenceDataIdentifier: "", referenceDescription: "Select"));
    conditionList.addAll(uldConditionCodeList);


    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {

        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {

              return WillPopScope(
                onWillPop: () async{
                  Navigator.pop(context, {
                    "status": "N",
                  });
                  return true; // Allow the modal to close
                },
                child: BlocListener<PalletStackCubit, PalletStackState>(
                  listener: (context, state) {
                  if (state is PalletStackInitialState) {
                  }
                  else if (state is PalletStackLoadingState) {
                    // showing loading dialog in this state
                    DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                  }
                  else if (state is PalletStackUpdateULDConditionCodeSuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.palletStackUpdateULDConditionCodeModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                      // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.palletStackUpdateULDConditionCodeModel.statusMessage!;
                      });
                    }else{

                      Navigator.pop(context, {
                        "status": "D",
                      });

                      SnackbarUtil.showSnackbar(context, state.palletStackUpdateULDConditionCodeModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                    }
                  }
                  else if (state is PalletStackAssignFlightFailureState){
                    Vibration.vibrate(duration: 500);
                    setState(() {
                      errorText = state.error;
                    });
                  }

                },

                  child:Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,  // Adjust the width to 90% of the screen width
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 2,
                            horizontal: SizeConfig.blockSizeHorizontal * 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                  InkWell(
                                      onTap: () {


                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                      child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              Row(
                                children: [
                                  SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                  Flexible(
                                    child: CustomeText(
                                      text: "${lableModel.addupdateconditioncode} ${uldNo}",
                                      fontColor: MyColor.textColorGrey2,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical),

                              DropdownButtonHideUnderline(
                                child: DropdownButton<ULDConditionCodeList>(
                                  isExpanded: true, // Make the dropdown content full width
                                  value: null, // Set the value to null so no label is shown when closed
                                  hint: Container(
                                    padding: EdgeInsets.all(10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: MyColor.colorWhite,
                                      borderRadius:BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: MyColor.colorBlack.withOpacity(0.09),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomeText( // Placeholder text when dropdown is closed
                                          text: conditionName, // Show the label name as hint text
                                          fontColor: MyColor.colorBlack,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.start,
                                        ),
                                        SvgPicture.asset(circleDown, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3, color: MyColor.colorBlack ,)
                                      ],
                                    ),
                                  ), // Dropdown icon
                                  iconEnabledColor: Colors.transparent,
                                  onChanged: (ULDConditionCodeList? newValue) {
                                    if (newValue != null) {
                                      String name = newValue.referenceDescription!;
                                      String type = newValue.referenceDataIdentifier!;

                                      setState(() {
                                        errorText = "";
                                        conditionType = type;
                                        conditionName = name; // Set the language name for display
                                      });

                                    }
                                  },
                                  dropdownColor: Colors.white, // Set dropdown background color to white
                                  items: conditionList.map<DropdownMenuItem<ULDConditionCodeList>>((ULDConditionCodeList designType) {

                                    return DropdownMenuItem<ULDConditionCodeList>(
                                      value: designType,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          CustomeText(
                                            text: designType.referenceDescription ?? '',
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                          ),
                                         /* if (languageCode == _selectedLanguage)
                                            Icon(Icons.done, color: Colors.black), */// Show done icon for selected language
                                        ],
                                      ),
                                    );
                                  }).toList() ?? [],
                                ),
                              ),

                              (errorText.isNotEmpty) ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              if (errorText.isNotEmpty)  // Show error text if not empty
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomeText(
                                    text: errorText,
                                    fontColor: MyColor.colorRed,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      isborderButton: true,
                                      text: "${lableModel.cancel}",
                                      press: () {
                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "${lableModel.save}",
                                      press: () {

                                        if (conditionType.isNotEmpty) {
                                          context.read<PalletStackCubit>().getPalletUpdateULDConditionCode(uldSeqNo, conditionType, userIdentity, companyCode, menuId,);
                                        }
                                        else {

                                          setState(() {
                                            errorText = "${lableModel.selecteconditioncode}";
                                          });

                                          Vibration.vibrate(duration: 500);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

            }
        );
      },
    );
  }

  static Future<Map<String, String>?> showPalletCloseDialog(
      BuildContext context,
      int uldSeqNo,
      LableModel lableModel,
      ui.TextDirection textDirection,
      int userIdentity,
      int companyCode,
      int menuId,
      String title,
      String messageBody,
      String uldNo) {

    String errorText = "";

    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {




        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {

              return WillPopScope(
                onWillPop: () async{
                  Navigator.pop(context, {
                    "status": "N",
                  });
                  return true; // Allow the modal to close
                },
                child: BlocListener<PalletStackCubit, PalletStackState>(listener: (context, state) {
                  if (state is PalletStackInitialState) {
                  }
                  else if (state is PalletStackLoadingState) {
                    // showing loading dialog in this state
                    DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                  }
                  else if (state is RevokePalletStackSuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.revokePalletStackModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                      // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.revokePalletStackModel.statusMessage!;
                      });
                    }else{

                      Navigator.pop(context, {
                        "status": "D",
                      });

                      SnackbarUtil.showSnackbar(context, state.revokePalletStackModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                    }
                  }
                  else if (state is RevokePalletStackFailureState){
                    DialogUtils.hideLoadingDialog(context);
                    Vibration.vibrate(duration: 500);
                    setState(() {
                      errorText = state.error;
                    });
                  }
                  else if (state is ReopenClosePalletStackASuccessState){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.reopenClosePalletStackModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                      // SnackbarUtil.showSnackbar(context, state.airportCityModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      setState(() {
                        errorText = state.reopenClosePalletStackModel.statusMessage!;
                      });
                    }else{

                      Navigator.pop(context, {
                        "status": "D",
                      });

                      SnackbarUtil.showSnackbar(context, state.reopenClosePalletStackModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                    }
                  }
                  else if (state is ReopenClosePalletStackAFailureState){
                    DialogUtils.hideLoadingDialog(context);
                    Vibration.vibrate(duration: 500);
                    setState(() {
                      errorText = state.error;
                    });
                  }
                },

                  child:Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,  // Adjust the width to 90% of the screen width
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 2,
                            horizontal: SizeConfig.blockSizeHorizontal * 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                  InkWell(
                                      onTap: () {


                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                      child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              Row(
                                children: [
                                  SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                  Flexible(
                                    child: CustomeText(
                                      text: messageBody,
                                      fontColor: MyColor.textColorGrey2,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical),

                              (errorText.isNotEmpty) ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              if (errorText.isNotEmpty)  // Show error text if not empty
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomeText(
                                    text: errorText,
                                    fontColor: MyColor.colorRed,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      isborderButton: true,
                                      text: "${lableModel.cancel}",
                                      press: () {
                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonGreen(
                                      color: MyColor.colorRed,
                                      text: "${lableModel.reOpen}",
                                      press: () {
                                        context.read<PalletStackCubit>().reopenClosePalletStackA(uldSeqNo, "R", userIdentity, companyCode, menuId,);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonGreen(
                                      color: MyColor.colorRed,
                                      text: "${lableModel.revoke}",
                                      press: () {
                                        context.read<PalletStackCubit>().revokePalletStack(uldSeqNo, userIdentity, companyCode, menuId,);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

            }
        );
      },
    );
  }


  static Future<bool?> showPalletCompleteDialog(BuildContext context, String uldNo, LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "Close Pallet",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: "Do you want to close pallet ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }
  static Future<bool?> removePalletDialog(BuildContext context, String uldNo, LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: "Remove Pallet",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: "Do you want to remove pallet ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }


  static Future<bool?> cancelULDDialog(BuildContext context, String uldNo, String title, String message, LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )


          ],
        );
      },
    );
  }


  static Future<bool?> closeUnloadULDDialog(BuildContext context,
      String uldNo,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  static Future<Map<String, String>?> showRemoveShipmentDialog(
      BuildContext context,
      int flightSeqNo,
      String uldType,
      int uldSeqNo,
      int emiseqNo,
      int awbShipRowId,
      int nop,
      double weight,
      int groupIdChar,
      String groupIdRequired,
      LableModel lableModel,
      ui.TextDirection textDirection,
      int userIdentity,
      int companyCode,
      int menuId,
      String title,
      String messageBody,
      String flagBtn) {

    String errorText = "";


    TextEditingController nopController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController groupIdController = TextEditingController();
    TextEditingController remarkController = TextEditingController();

    FocusNode nopFocusNode = FocusNode();
    FocusNode weightFocusNode = FocusNode();
    FocusNode groupIdFocusNode = FocusNode();
    FocusNode remarkFocus = FocusNode();

    double weightCount = 0.00;

    int totalNop = 0;
    double totalWt = 0.00;

    int differenceNop = 0;
    double differenceWeight = 0.00;

    totalNop = int.parse("${nop}");
    totalWt = double.parse("${weight}");




    nopController.text = totalNop.toString();
    weightController.text = totalWt.toStringAsFixed(2);

    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {




        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {

              return WillPopScope(
                onWillPop: () async{
                  Navigator.pop(context, {
                    "status": "N",
                  });
                  return true; // Allow the modal to close
                },
                child: BlocListener<UnloadULDCubit, UnloadULDState>(listener: (context, state) {
                  if (state is UnloadULDInitialState) {
                  }
                  else if (state is UnloadULDLoadingState) {
                    // showing loading dialog in this state
                    DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                  }
                  else if (state is UnloadRemoveAWBSuccessStateA){
                    DialogUtils.hideLoadingDialog(context);
                    if(state.unloadRemoveAWBModel.status == "E"){
                      Vibration.vibrate(duration: 500);
                      setState(() {
                        errorText = state.unloadRemoveAWBModel.statusMessage!;
                      });
                    }
                    else if(state.unloadRemoveAWBModel.status == "C"){
                      Navigator.pop(context, {
                        "status": "C",
                      });
                    }
                    else{

                      SnackbarUtil.showSnackbar(context, state.unloadRemoveAWBModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                      Navigator.pop(context, {
                        "status": "D",
                      });
                    }
                  }
                  else if (state is UnloadRemoveAWBFailureStateA){
                    DialogUtils.hideLoadingDialog(context);
                    Vibration.vibrate(duration: 500);
                    setState(() {
                      errorText = state.error;
                    });
                  }

                },

                  child:Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(newContext).viewInsets.bottom,  // Adjust for keyboard
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,  // Adjust the width to 90% of the screen width
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 2,
                            horizontal: SizeConfig.blockSizeHorizontal * 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomeText(text: title, fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                      child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              Row(
                                children: [
                                  SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                  Flexible(
                                    child: CustomeText(
                                      text: messageBody,
                                      fontColor: MyColor.textColorGrey2,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),

                              Row(
                                children: [
                                  Expanded(
                                      flex:1,
                                      child: Directionality(
                                        textDirection: textDirection,
                                        child: CustomTextField(
                                          textDirection: textDirection,
                                          controller: nopController,
                                          focusNode: nopFocusNode,
                                          onPress: () {},
                                          hasIcon: false,
                                          maxLength: 4,
                                          hastextcolor: true,
                                          animatedLabel: true,
                                          needOutlineBorder: true,
                                          labelText: "${lableModel.pieces}",
                                          readOnly: (flagBtn == "B") ? true : false,
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              int enteredNop = int.tryParse(value) ?? 0;

                                              if (enteredNop > totalNop) {
                                                // Exceeds total NOP, show an error

                                                Vibration.vibrate(duration: 500);
                                                setState(() {
                                                  differenceNop = totalNop - enteredNop;
                                                  weightCount = double.parse(((enteredNop * totalWt) / totalNop).toStringAsFixed(2));
                                                  weightController.text = weightCount.toStringAsFixed(2);
                                                  differenceWeight = totalWt - weightCount;
                                                  errorText = "${lableModel.exceedstotalnop}";
                                                });
                                              } else {
                                                // Update the differences and weight
                                                setState(() {
                                                  differenceNop = totalNop - enteredNop;
                                                  //weightCount = (totalWt / totalNop) * enteredNop;
                                                  weightCount = double.parse(((enteredNop * totalWt) / totalNop).toStringAsFixed(2));
                                                  weightController.text = weightCount.toStringAsFixed(2);
                                                  differenceWeight = totalWt - weightCount;
                                                  errorText = "";
                                                });
                                              }
                                            } else {
                                              // Reset to defaults when cleared
                                              setState(() {
                                                differenceNop = totalNop;
                                                differenceWeight = totalWt;
                                                weightCount = 0.0;
                                                weightController.text = "";
                                                errorText = "";
                                              });
                                            }



                                          },
                                          fillColor:  Colors.grey.shade100,
                                          textInputType: TextInputType.number,
                                          inputAction: TextInputAction.next,
                                          hintTextcolor: Colors.black45,
                                          verticalPadding: 0,
                                          digitsOnly: true,

                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                          circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                          boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please fill out this field";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      )
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  Expanded(
                                    flex: 1,
                                    child: Directionality(
                                      textDirection: textDirection,
                                      child: CustomTextField(
                                        textDirection: textDirection,
                                        controller: weightController,
                                        focusNode: weightFocusNode,
                                        nextFocus: groupIdFocusNode,
                                        onPress: () {},
                                        hasIcon: false,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "${lableModel.weight}",
                                        readOnly: (flagBtn == "B") ? true : (differenceNop == 0) ? true : false,
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            double enteredWeight = double.tryParse(value) ?? 0.00;

                                            if (enteredWeight > totalWt) {
                                              // Exceeds total weight, show an error
                                              Vibration.vibrate(duration: 500);
                                              setState(() {
                                                errorText = "${lableModel.exceedstotalWeight}";
                                                differenceWeight = totalWt - enteredWeight;
                                              });
                                            } else {
                                              // Update the weight difference
                                              setState(() {
                                                differenceWeight = totalWt - enteredWeight;
                                                if (differenceNop != 0 && differenceWeight == 0) {
                                                  Vibration.vibrate(duration: 500);
                                                  errorText = "${lableModel.remainingpcsavailable}";
                                                } else {
                                                  errorText = "";
                                                }
                                              });
                                            }
                                          } else {
                                            // Reset to defaults when cleared
                                            setState(() {
                                              differenceWeight = totalWt;
                                              errorText = "";
                                            });
                                          }
                                        },
                                        fillColor:  Colors.grey.shade100,
                                        textInputType: TextInputType.number,
                                        inputAction: TextInputAction.next,
                                        hintTextcolor: Colors.black45,
                                        verticalPadding: 0,
                                        maxLength: 10,
                                        digitsOnly: false,
                                        doubleDigitOnly: true,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                        circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                        boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please fill out this field";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              (flagBtn == "A") ? Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomeText(
                                      text: "${lableModel.remainingNop} : $differenceNop",
                                      fontColor: MyColor.colorRed,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  Expanded(
                                    flex: 1,
                                    child: CustomeText(
                                      text: "${lableModel.remainingWeight} : ${differenceWeight.toStringAsFixed(2)}",
                                      fontColor: MyColor.colorRed,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ) : SizedBox(),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              // text manifest and recived in pices text counter
                              Directionality(
                                textDirection: textDirection,
                                child: CustomTextField(
                                  textDirection: textDirection,
                                  controller: groupIdController,
                                  focusNode: groupIdFocusNode,
                                  onPress: () {},
                                  hasIcon: false,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: groupIdRequired == "Y" ? "${lableModel.groupId} *" : "${lableModel.groupId}",
                                  readOnly: false,
                                  maxLength: (groupIdChar == 0) ? 1 : groupIdChar,
                                  onChanged: (value) {
                                    if(groupIdController.text.isNotEmpty){
                                      setState(() {
                                        errorText = "";
                                      });
                                    }
                                  },
                                  fillColor: Colors.grey.shade100,
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  hintTextcolor: Colors.black45,
                                  verticalPadding: 0,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please fill out this field";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              RemarkCustomTextField(
                                textDirection: textDirection,
                                controller: remarkController,
                                focusNode: remarkFocus,
                                hasIcon: false,
                                hastextcolor: true,
                                animatedLabel: true,
                                needOutlineBorder: true,
                                labelText: lableModel.remarks,
                                onChanged: (value, validate) {},
                                readOnly: false,
                                fillColor: Colors.grey.shade100,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.next,
                                hintTextcolor: Colors.black45,
                                maxLines: 1,
                                maxLength: 500,
                                digitsOnly: false,
                                doubleDigitOnly: false,
                                verticalPadding: 0,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8,

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill out this field";
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical),

                              (errorText.isNotEmpty) ? SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              if (errorText.isNotEmpty)  // Show error text if not empty
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomeText(
                                    text: errorText,
                                    fontColor: MyColor.colorRed,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              CustomDivider(
                                space: 0,
                                color: Colors.black,
                                hascolor: true,
                                thickness: 1,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      isborderButton: true,
                                      text: "${lableModel.cancel}",
                                      press: () {
                                        Navigator.pop(context, {
                                          "status": "N",
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonGreen(
                                      color: MyColor.colorRed,
                                      text: "${lableModel.remove}",
                                      press: () {
                                        if (nopController.text.isEmpty) {

                                          setState(() {
                                            errorText = "${lableModel.piecesMsg}";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(nopFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }

                                        if(int.parse(nopController.text) == 0){
                                          setState(() {
                                            errorText = "${lableModel.enterPiecesGrtMsg}";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(nopFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }

                                        if (weightController.text.isEmpty) {
                                          setState(() {
                                            errorText = "${lableModel.weightMsg}";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }

                                        if(double.parse(weightController.text) == 0){
                                          setState(() {
                                            errorText = "${lableModel.enterWeightGrtMsg}";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }


                                        if (int.parse(nopController.text) > totalNop) {
                                          // Exceeds total NOP, show an error
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(nopFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          setState(() {
                                            errorText = "${lableModel.exceedstotalnop}";
                                          });
                                          return;
                                        }

                                        if (double.parse(weightController.text) > totalWt) {
                                          // Exceeds total weight, show an error
                                          Vibration.vibrate(duration: 500);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          setState(() {
                                            errorText = "${lableModel.exceedstotalWeight}";
                                          });
                                          return;
                                        }

                                        if (differenceNop != 0 && differenceWeight == 0) {
                                          Vibration.vibrate(duration: 500);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          setState(() {
                                            errorText = "${lableModel.remainingpcsavailable}";
                                          });

                                          return;
                                        }

                                        /*int remainingNop = totalNop - int.parse(nopController.text);
                                        if (remainingNop == 0) {
                                          setState(() {
                                            errorText = "Remaining pcs not 0";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(nopFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }

                                        double remainingWeight = totalWt - double.parse(weightController.text);
                                        if (remainingWeight <= 0) {
                                          setState(() {
                                            errorText = "remaining weight not set 0";
                                          });
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }*/



                                        if(groupIdRequired == "Y"){
                                          if (groupIdController.text.isEmpty) {
                                            setState(() {
                                              errorText = "${lableModel.enterGropIdMsg}";
                                            });
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);
                                            return;
                                          }
                                          // Check if the groupId length is between 14 (min and max 14 characters)
                                          if (groupIdController.text.length != groupIdChar) {
                                            setState(() {
                                              errorText = formatMessage("${lableModel.groupIdCharSizeMsg}", ["${groupIdChar}"]);
                                            });
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);
                                            return;
                                          }

                                        }

                                        context.read<UnloadULDCubit>().unloadRemoveAWBLoadA(flightSeqNo,  "${uldType}_${uldSeqNo}_${emiseqNo}_${awbShipRowId}", int.parse(nopController.text), double.parse(weightController.text), remarkController.text, groupIdController.text , userIdentity, companyCode, menuId);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

            }
        );
      },
    );
  }


  static Future<bool?> unlodeRemoveShipmentDialog(BuildContext context,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  static Future<bool?> removeFlightFromULDDialog(BuildContext context,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }


  static Future<String?> showTareWtChangeBottomULDDialog(BuildContext context, String uldNo, String tareWeight, LableModel lableModel, ui.TextDirection textDirection) {
    TextEditingController batteryController = TextEditingController();
    FocusNode batteryFocusNode = FocusNode();
    batteryController.text = tareWeight;


    String errorText = "";

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,  // Ensures the bottom sheet adjusts when the keyboard is opened
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(batteryFocusNode);
        });

        return StatefulBuilder(
          builder:(BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,  // Adjust for keyboard
              ),
              child: FractionallySizedBox(
                widthFactor: 1,  // Adjust the width to 90% of the screen width
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(text: "Change Tare Weight", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                                },
                                child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,)),
                          ],
                        ),
                      ),
                      CustomDivider(
                        space: 0,
                        color: MyColor.textColorGrey,
                        hascolor: true,
                        thickness: 1,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 6),
                        child: Row(
                          children: [
                            SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal,
                            ),
                            CustomeText(
                              //text: "Change battery for this ${uldNo}",
                                text : CommonUtils.formatMessage("Change Tare weight for this {0}", [uldNo]),
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.start)
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                        child: CustomTextField(
                          focusNode: batteryFocusNode,
                          textDirection: textDirection,
                          hasIcon: false,
                          hastextcolor: true,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: "${lableModel.tareWt}",
                          controller: batteryController,
                          readOnly: false,
                          maxLength: 10,
                          digitsOnly: false,
                          doubleDigitOnly: true,
                          onChanged: (value, validate) {
                            if(batteryController.text.isEmpty){
                              setState(() {
                                errorText = "0.00";
                              });
                            }

                          },
                          fillColor: Colors.grey.shade100,
                          textInputType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          hintTextcolor: Colors.black,
                          verticalPadding: 0,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                          circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                          boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please fill out this field";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      if (errorText.isNotEmpty)  // Show error text if not empty
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 8),
                          child: CustomeText(
                            text: errorText,
                            fontColor: MyColor.colorRed,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                      CustomDivider(
                        space: 0,
                        color: MyColor.textColorGrey,
                        hascolor: true,
                        thickness: 1,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RoundedButtonBlue(
                                text: "${lableModel.cancel}",
                                isborderButton: true,
                                press: () {
                                  Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: RoundedButtonBlue(
                                text: "${lableModel.save}",
                                press: () {

                                  if (batteryController.text.isEmpty) {
                                    setState(() {
                                      errorText = "${lableModel.betterymsg}";
                                    });
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(batteryFocusNode);
                                    });
                                    Vibration.vibrate(duration: 500);
                                    return;
                                  }



                                  Navigator.pop(context, batteryController.text);  // Return the text when "Save" is pressed
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },);




      },
    );
  }


  static Future<bool?> closeReopenULDDialog(BuildContext context,
      String uldNo,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  static Future<bool?> commingSoonDialog(BuildContext context,
      String title,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: Center(child: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.center, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600)),
          content: RoundedButtonBlue(text: "${lableModel.ok}", press: () {
            Navigator.of(context).pop(false);
          },),

        );
      },
    );
  }

  static Future<int?> showBulkMoreOptionDialog(BuildContext context, String message, LableModel lableModel) {


    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1, // Adjust the width to 90% of the screen width
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 2,
              horizontal: SizeConfig.blockSizeHorizontal * 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomeText(
                  text: message,
                  fontColor: MyColor.colorBlack,
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical ),

                CustomDivider(
                  space: 0,
                  color: MyColor.textColorGrey,
                  hascolor: true,
                  thickness: 1,
                ),

                RoundedButtonGreen(
                  color: MyColor.btnColor3,
                  textColor: MyColor.textColorGrey3,
                  verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                  textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                  text: "${lableModel.scale}",

                  press: () {
                    Navigator.pop(context, 1);
                  },
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButtonBlue(
                        isborderButton: true,
                        text: "${lableModel.cancel}",
                        color: MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        text: "Close BULK",
                        color: MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context, 2);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<int?> showULDMoreOptionDialog(BuildContext context, String message, LableModel lableModel) {


    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1, // Adjust the width to 90% of the screen width
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 2,
              horizontal: SizeConfig.blockSizeHorizontal * 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomeText(
                  text: message,
                  fontColor: MyColor.colorBlack,
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical ),

                CustomDivider(
                  space: 0,
                  color: MyColor.textColorGrey,
                  hascolor: true,
                  thickness: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButtonGreen(
                        color: MyColor.btnColor1,
                        textColor: MyColor.textColorGrey3,
                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                        text: "${lableModel.equipment}",
                        press: () {
                          Navigator.pop(context, 1);
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                    Expanded(
                      flex: 1,
                      child: RoundedButtonGreen(
                        color: MyColor.btnColor2,
                        textColor: MyColor.textColorGrey3,
                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                        text: "${lableModel.contour}",

                        press: () {
                          Navigator.pop(context, 2);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButtonGreen(
                        color: MyColor.btnColor3,
                        textColor: MyColor.textColorGrey3,
                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                        text: "${lableModel.scale}",

                        press: () {
                          Navigator.pop(context, 3);
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                    Expanded(
                      flex: 1,
                      child: RoundedButtonGreen(
                        color: MyColor.btnColor4,
                        textColor: MyColor.textColorGrey3,
                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                        text: "${lableModel.addMail}",
                        press: () {
                          Navigator.pop(context, 4);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButtonBlue(
                        isborderButton: true,
                        text: "${lableModel.cancel}",
                        color: MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        text: "${lableModel.closeULD}",
                        color: MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context, 5);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<int?> showTrolleyMoreOptionDialog(BuildContext context, String message, LableModel lableModel, String trolleyStatus) {


    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1, // Adjust the width to 90% of the screen width
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 2,
              horizontal: SizeConfig.blockSizeHorizontal * 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomeText(
                  text: message,
                  fontColor: MyColor.colorBlack,
                  fontSize: SizeConfig.textMultiplier * 2.2,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical ),

                CustomDivider(
                  space: 0,
                  color: MyColor.textColorGrey,
                  hascolor: true,
                  thickness: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButtonGreen(
                        color: MyColor.btnColor1,
                        textColor: MyColor.textColorGrey3,
                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                        text: "${lableModel.equipment}",
                        press: () {
                          Navigator.pop(context, 1);
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                    Expanded(
                      flex: 1,
                      child: RoundedButtonGreen(
                        color: MyColor.btnColor3,
                        textColor: MyColor.textColorGrey3,
                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                        text: "${lableModel.scale}",

                        press: () {
                          Navigator.pop(context, 2);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RoundedButtonBlue(
                        isborderButton: true,
                        text: "${lableModel.cancel}",
                        color: MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                    Expanded(
                      flex: 1,
                      child: RoundedButton(
                        text: "${lableModel.closeTrolley}",
                        color: MyColor.primaryColorblue,
                        press: () {
                          Navigator.pop(context, 3);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


  static Future<bool?> addShipmentDiffOffPointDialog(BuildContext context,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )


          ],
        );
      },
    );
  }


  static Future<bool?> damageULDExportDialog(BuildContext context,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
              CustomeText(text: "Do you wan't to record damage ?", fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
            ],
          ),
          actions: <Widget>[


            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )


          ],
        );
      },
    );
  }


  static Future<bool?> commonDialogforWarning(BuildContext context,
      String title,
      String message,
      LableModel lableModel) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Set custom corner radius
          ),
          title: CustomeText(text: title,fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: Flexible(child: CustomeText(text: message, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400, maxLine: 4,)),
          actions: <Widget>[

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.cancel}",
                    isborderButton: true,
                    press: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                Expanded(
                  flex: 1,
                  child: RoundedButtonBlue(
                    text: "${lableModel.ok}",
                    press: () {

                      Navigator.of(context).pop(true);

                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }


}
