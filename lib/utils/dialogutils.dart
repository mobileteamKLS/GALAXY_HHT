import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/language/model/dashboardModel.dart';
import 'package:galaxy/language/model/lableModel.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/utils/validationmsgcodeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/roundbutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../core/images.dart';
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
          title: CustomeText(text: "${dashboardModel.logout}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${dashboardModel.logoutMsg}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
                child: CustomeText(text: "${dashboardModel.cancel}",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.8,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${dashboardModel.ok}",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

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
          title: CustomeText(text: "${dashboardModel.exit}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${dashboardModel.exitMsg}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "${dashboardModel.cancel}",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.8,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${dashboardModel.exit}",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

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
          title: CustomeText(text: "${lableModel.finalizeflight}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${lableModel.finalizeflightMsg}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "${lableModel.cancel}",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.8,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${lableModel.ok}",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

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
          return Center(
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
          title: CustomeText(text: "${lableModel.revokeDamage}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          // content: CustomeText(text: (bdEndStatus == "Y") ? "Breakdown already completed this ${uldNo}" : uldProgress < 100 ? "Are you sure you want to complete this ${uldNo} breakdown ?" : "${uldNo} breakdown completed ?",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          content: CustomeText(text: "${lableModel.revokeDamageMsg}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "${lableModel.no}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

           SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),

           InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${lableModel.yes}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

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
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "${lableModel.no}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${lableModel.yes}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            text: "${lableModel.changePriorityMSG} ${uldNo}",
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
                                      }else{
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
          title: CustomeText(text: "${uldTitleMsg}",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${lableModel.emptyULDMessage}",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "${lableModel.no}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w500)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.8,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${lableModel.yes}",fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w500)),

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
          title: CustomeText(text: "${lableModel.lastBTConfirm}",fontSize: SizeConfig.textMultiplier * 2.1, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "${lableModel.lastBTMsg}",fontSize: SizeConfig.textMultiplier * 1.8, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "${lableModel.cancel}",fontSize: SizeConfig.textMultiplier * 1.8, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.8,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "${lableModel.ok}",fontSize: SizeConfig.textMultiplier * 1.8, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

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
            borderRadius: BorderRadius.all(Radius.circular(20)),
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


}
