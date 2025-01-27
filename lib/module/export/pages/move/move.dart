import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/model/buildup/getuldtrolleysearchmodel.dart';
import 'package:galaxy/module/export/services/move/movelogic/movecubit.dart';
import 'package:galaxy/module/export/services/move/movelogic/movestate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/move/getmovesearch.dart';

class MovePage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  MovePage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<MovePage> createState() => _MovePageState();
}

class _MovePageState extends State<MovePage> with SingleTickerProviderStateMixin{

  String destinationWarningInd = "N";
  String shcCompibilityWarningInd = "N";
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();

  FocusNode groupIdFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();
  FocusNode removeGroupBtnFocusNode = FocusNode();
  FocusNode removeULDTrolleyBtnFocusNode = FocusNode();
  FocusNode clearBtnFocusNode = FocusNode();
  FocusNode moveBtnFocusNode = FocusNode();


  bool isBackPressed = false; // Track if the back button was pressed


  GetMoveSearchModel? getMoveSearchModel;
  List<GroupDetailList>? getGroupDetailList = [];
  List<ULDTrolleyDetailsList>? getULDTrolleyDetailsList = [];


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;
  String selectedType = "G";
  String pickType = "";
  String dropLocation = "";
  String dropLocationType = "";
  ULDTrolleyDetailsList? uldTrolleyForDrop;
  bool addShipmentComplete = false;
  int groupSelectIndex = 0;
  int uldTrolleySelectIndex = 0;



  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state

  Map<GroupDetailList, bool> groupSwitchStates = {}; // For GroupDetailList
  Map<ULDTrolleyDetailsList, bool> uldTrolleySwitchStates = {}; // For ULDTrolleyDetailsList
  bool _isSelectAll = false;


  @override
  void initState() {
    super.initState();
  //  switchStates = List<bool>.filled(listValue.length, false);

    _loadUser(); //load user data

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController);



    groupIdFocusNode.addListener(() {
      if (!groupIdFocusNode.hasFocus && !isBackPressed) {
        leaveGroupIdFocus();
      }
    });



  }


  void toggleGroupSwitch(GroupDetailList id, bool value) {
    setState(() {
      groupSwitchStates[id] = value;
    });
  }

  void toggleTrolleySwitch(ULDTrolleyDetailsList id, bool value) {
    setState(() {
      uldTrolleySwitchStates[id] = value;
    });
  }
  void toggleSelectAll(bool value) {
    setState(() {
      _isSelectAll = value;

      // Update all group switch states
      groupSwitchStates.updateAll((key, _) => value);

      // Update all ULD trolley switch states
      uldTrolleySwitchStates.updateAll((key, _) => value);
    });
  }



  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;


    // Skip focus leave logic if "Clear" button is clicked
    if (clearBtnFocusNode.hasFocus) return;

    // Skip focus leave logic if "Clear" button is clicked
    if (moveBtnFocusNode.hasFocus) return;

    // Skip focus leave logic if "Clear" button is clicked
    if (removeGroupBtnFocusNode.hasFocus) return;

    if (removeULDTrolleyBtnFocusNode.hasFocus) return;

    if (groupIdController.text.isNotEmpty) {
      getMoveSearch();
    }else{

    }
  }


  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    groupIdFocusNode.dispose();
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
  }

  Future<void> _loadUser() async {

    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(groupIdFocusNode);
    });

    //context.read<BinningCubit>().getPageLoadDefault(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    groupIdFocusNode.unfocus();
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(groupIdFocusNode);
      },
      );
    } else {
      _logoutUser();
    }
  }

  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignInScreenMethod(),
      ),
      (route) => false,
    );
  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {
    isBackPressed = true; // Set to true to avoid showing snackbar on back press
    FocusScope.of(context).unfocus();
    groupIdFocusNode.unfocus();
    Navigator.pop(context);
    inactivityTimerManager?.stopTimer();
    return false; // Prevents the default back button action
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // localize value form assets
    AppLocalizations? localizations = AppLocalizations.of(context);
    LableModel? lableModel = localizations!.lableModel;

    //ui direction not change for arabic
    ui.TextDirection uiDirection =
        localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
            ? ui.TextDirection.ltr
            : ui.TextDirection.ltr;

    //text direction change for arabic
    ui.TextDirection textDirection =
        localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr;

    // ui direction change arabic language
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _resumeTimerOnInteraction,
        // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(),
        // Resuming on any gesture
        child: Directionality(
          textDirection: uiDirection,
          child: SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              drawer: _user != null && _splashDefaultData != null
                  ? BuildCustomeDrawer(
                importSubMenuList: widget.importSubMenuList,
                exportSubMenuList: widget.exportSubMenuList,
                user: _user!,
                splashDefaultData: _splashDefaultData!,
              onDrawerCloseIcon: () {
                isBackPressed = false; // Set to true to avoid showing snackbar on back press
                _scaffoldKey.currentState?.closeDrawer();
              },) : null, // Add custom drawer widget here
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName,
                  onDrawerIconTap: () {
                    isBackPressed = true; // Set to true to avoid showing snackbar on back press
                    _scaffoldKey.currentState?.openDrawer();
                  },
                    onUserProfileIconTap: () {
                      isBackPressed = true; // Set to true to avoid showing snackbar on back press
                      FocusScope.of(context).unfocus();
                      groupIdFocusNode.unfocus();
                      _scaffoldKey.currentState?.closeDrawer();
                      // navigate to profile picture
                      inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const Profilepagescreen(),));
                    },

                  /*  onDrawerIconTap: () => _scaffoldKey.currentState?.openDrawer(),*/
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scroll) {
                        _resumeTimerOnInteraction(); // Reset the timer on scroll event
                        return true;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.bgColorGrey,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.title,
                                onBack: () {
                                  _onWillPop();
                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  groupIdController.clear();
                                  pickType = "";
                                  dropLocationType = "";
                                  dropLocation = "";
                                  selectedType = "G";
                                  _isSelectAll = false;
                                  getGroupDetailList!.clear();
                                  getULDTrolleyDetailsList!.clear();
                                  addShipmentComplete = false;
                                  uldTrolleyForDrop = null;
                                  // Clear all switch states
                                  groupSwitchStates.clear();
                                  uldTrolleySwitchStates.clear();

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  });
                                  // Reset UI
                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<MoveCubit, MoveState>(
                              listener: (context, state) async {
                                if (state is MoveInitialState) {
                                }
                                else if (state is MoveLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is GetMoveSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getMoveSearchModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getMoveSearchModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                  }
                                  else{

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );

                                    getMoveSearchModel = state.getMoveSearchModel;
                                    List<GroupDetailList>? newGroupDetailList = getMoveSearchModel!.groupDetailList;
                                    List<ULDTrolleyDetailsList>? newULDTrolleyDetailsList = getMoveSearchModel!.uLDTrolleyDetailsList;


                                    if(selectedType == "G"){
                                      if (newGroupDetailList != null) {
                                        for (var group in newGroupDetailList) {
                                          if(group.groupSeqNo == -1){
                                            dropLocation = group.dropLocation!;
                                            dropLocationType = "G";
                                          }else{
                                            pickType = selectedType;
                                            bool exists = getGroupDetailList!.any((existingGroup) => existingGroup.groupSeqNo == group.groupSeqNo);
                                            if (!exists) {
                                              getGroupDetailList!.add(group);
                                              groupSwitchStates[group] = true; // Initialize switch state
                                            }
                                          }
                                        }
                                      }
                                    }
                                    else{
                                      // Update ULDTrolleyDetailsList without duplicates
                                      if (newULDTrolleyDetailsList != null) {
                                        for (var trolley in newULDTrolleyDetailsList) {
                                          if(trolley.uLDTrolleySeqNo == -1){
                                            dropLocation = trolley.dropLocation!;
                                            dropLocationType = "G";
                                          }else{
                                            if(pickType == "G"){
                                              uldTrolleyForDrop = trolley;
                                              dropLocation = "${trolley.uLDTrolleyType} ${trolley.uLDTrolleyNo} ${trolley.uLDOwner}";
                                              if(pickType == "G" && selectedType == "U"){
                                                dropLocationType = "U";
                                              }else{
                                                dropLocationType = "T";
                                              }

                                            }else{
                                              pickType = selectedType;
                                              bool exists = getULDTrolleyDetailsList!.any((existingTrolley) => existingTrolley.uLDTrolleySeqNo == trolley.uLDTrolleySeqNo);
                                              if (!exists) {
                                                getULDTrolleyDetailsList!.add(trolley);
                                                uldTrolleySwitchStates[trolley] = true; // Initialize switch state
                                              }
                                            }

                                          }
                                        }
                                      }
                                    }


                                    setState(() {

                                    });
                                  }

                                }
                                else if (state is GetMoveSearchFailureState){
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  },
                                  );
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is MoveLocationSuccessState){
                                 DialogUtils.hideLoadingDialog(context);
                                 if(state.moveLocationModel.status == "E"){
                                   Vibration.vibrate(duration: 500);
                                   SnackbarUtil.showSnackbar(context, state.moveLocationModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                   WidgetsBinding.instance.addPostFrameCallback((_) {
                                     FocusScope.of(context).requestFocus(groupIdFocusNode);
                                   },
                                   );
                                 }else if(state.moveLocationModel.status == "V"){
                                   Vibration.vibrate(duration: 500);
                                   SnackbarUtil.showSnackbar(context, state.moveLocationModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                   WidgetsBinding.instance.addPostFrameCallback((_) {
                                     FocusScope.of(context).requestFocus(groupIdFocusNode);
                                   },
                                   );
                                 }else{
                                   WidgetsBinding.instance.addPostFrameCallback((_) {
                                     FocusScope.of(context).requestFocus(groupIdFocusNode);
                                   },
                                   );
                                   groupIdController.clear();
                                   if(pickType == "G"){
                                     getSelectedGroupIds().forEach((selectedGroup) {
                                       getGroupDetailList!.remove(selectedGroup); // Remove from the main list
                                       groupSwitchStates.remove(selectedGroup);   // Remove from switch states
                                     });
                                   }else{
                                     // Remove selected items from ULDTrolleyDetailsList
                                     getSelectedTrolleyIds().forEach((selectedTrolley) {
                                       getULDTrolleyDetailsList!.remove(selectedTrolley); // Remove from the main list
                                       uldTrolleySwitchStates.remove(selectedTrolley);    // Remove from switch states
                                     });
                                   }
                                   setState(() {});

                                   SnackbarUtil.showSnackbar(context, state.moveLocationModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                 }

                                }
                                else if (state is MoveLocationFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is AddShipmentMoveSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.addShipmentModel.status == "E"){
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );

                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.addShipmentModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else if(state.addShipmentModel.status == "W"){
                                    bool? addShipmentDiffDialog = await DialogUtils.addShipmentDiffOffPointDialog(context, "${lableModel.confirmDestination}", state.addShipmentModel.statusMessage! , lableModel);

                                    if(addShipmentDiffDialog == true){
                                      destinationWarningInd = "Y";
                                      List<GroupDetailList> selectedGroups = getSelectedGroupIds();
                                      int processedCount = 0;

                                      if(selectedGroups.length != 1){
                                        String warningMessage = selectedGroups.isEmpty
                                            ? "Please select 1 group."
                                            : "You can only select 1 group at a time.";

                                        // Display the warning message (you can use any method depending on your UI framework)
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, warningMessage, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                      }
                                      else{
                                        for (var selectedGroup in selectedGroups) {
                                          addShipment(
                                            selectedGroup.aWBPrefix!,
                                            selectedGroup.aWBNo!,
                                            selectedGroup.eXPAWBRowId!,
                                            selectedGroup.eXPShipRowId!,
                                            selectedGroup.nOP!,
                                            selectedGroup.weight!,
                                            selectedGroup.groupSeqNo!,
                                            destinationWarningInd,
                                            shcCompibilityWarningInd,
                                          );

                                          processedCount++;
                                          if (processedCount == selectedGroups.length) {
                                            // All items have been processed

                                            addShipmentComplete = true;
                                            setState(() {

                                            });

                                            print("All selected groups processed successfully.");
                                          }
                                        }


                                      }
                                    }
                                    else{

                                    }


                                  }
                                  else if(state.addShipmentModel.status == "C"){


                                    bool? addShipmentDiffDialog = await DialogUtils.addShipmentDiffOffPointDialog(context, "${lableModel.shcCompibility}", state.addShipmentModel.statusMessage! , lableModel);

                                    if(addShipmentDiffDialog == true){
                                      shcCompibilityWarningInd = "Y";
                                      List<GroupDetailList> selectedGroups = getSelectedGroupIds();
                                      int processedCount = 0;

                                      if(selectedGroups.length != 1){
                                        String warningMessage = selectedGroups.isEmpty
                                            ? "Please select 1 group."
                                            : "You can only select 1 group at a time.";

                                        // Display the warning message (you can use any method depending on your UI framework)
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, warningMessage, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                      }
                                      else{
                                        for (var selectedGroup in selectedGroups) {
                                          addShipment(
                                            selectedGroup.aWBPrefix!,
                                            selectedGroup.aWBNo!,
                                            selectedGroup.eXPAWBRowId!,
                                            selectedGroup.eXPShipRowId!,
                                            selectedGroup.nOP!,
                                            selectedGroup.weight!,
                                            selectedGroup.groupSeqNo!,
                                            destinationWarningInd,
                                            shcCompibilityWarningInd,
                                          );

                                          processedCount++;
                                          if (processedCount == selectedGroups.length) {
                                            // All items have been processed

                                            addShipmentComplete = true;
                                            setState(() {

                                            });

                                            print("All selected groups processed successfully.");
                                          }
                                        }


                                      }
                                    }
                                    else{

                                    }


                                  }

                                  else{

                                    if(addShipmentComplete == true){
                                      destinationWarningInd = "N";
                                      shcCompibilityWarningInd = "N";
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(groupIdFocusNode);
                                      },
                                      );
                                      groupIdController.clear();
                                      SnackbarUtil.showSnackbar(context, state.addShipmentModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                      getSelectedGroupIds().forEach((selectedGroup) {
                                        getGroupDetailList!.remove(selectedGroup); // Remove from the main list
                                        groupSwitchStates.remove(selectedGroup);   // Remove from switch states
                                      });
                                    }
                                  }
                                }
                                else if (state is AddShipmentMoveFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is RemoveMovementSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.removeMovementModel.status == "E"){
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                    groupIdController.clear();
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.removeMovementModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );

                                    groupIdController.clear();

                                    if(pickType == "G"){
                                      GroupDetailList removedGroup = getGroupDetailList!.removeAt(groupSelectIndex);
                                      // Remove the corresponding entry from the switch states
                                      groupSwitchStates.remove(removedGroup);
                                      setState(() {

                                      });
                                    }else{
                                      ULDTrolleyDetailsList removedGroup = getULDTrolleyDetailsList!.removeAt(uldTrolleySelectIndex);
                                      // Remove the corresponding entry from the switch states
                                      groupSwitchStates.remove(removedGroup);
                                      setState(() {

                                      });
                                    }
                                  }
                                }
                                else if (state is RemoveMovementFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColor.colorWhite,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: MyColor.colorBlack.withOpacity(0.09),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: SizeConfig.blockSizeVertical),
                                              // text manifest and recived in pices text counter
                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex :1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: groupIdController,
                                                        focusNode: groupIdFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: (selectedType == "G") ? "Scan Group Id Or Location" : (selectedType == "U") ? "Scan ULD Or Location" : "Scan Trolley Or Location",
                                                        readOnly: false,
                                                        maxLength: (selectedType == "G") ? 14 : (selectedType == "U") ? 11 : 15,
                                                        onChanged: (value) {
                                                          setState(() {

                                                          });
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
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal,
                                                    ),
                                                    // click search button to validate location
                                                    InkWell(
                                                      focusNode: scanBtnFocusNode,
                                                      onTap: () {
                                                        scanGroupQR();
                                                      },
                                                      child: Padding(padding: const EdgeInsets.all(8.0),
                                                        child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                      ),

                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        CustomeText(
                                                          text: "Pick :",
                                                          fontColor: MyColor.textColorGrey3,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                          fontWeight: FontWeight.w600,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        CustomeText(
                                                          text: (pickType == "G") ? "Group" : (pickType == "U") ? "ULD" : (pickType == "T") ? "Trolley" : "",
                                                          fontColor: Colors.pink.shade500,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                          fontWeight: FontWeight.bold,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        CustomeText(
                                                          text: "Drop :",
                                                          fontColor: MyColor.textColorGrey3,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                          fontWeight: FontWeight.w600,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        CustomeText(
                                                          text: dropLocation,
                                                          fontColor: MyColor.colorGreen,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                          fontWeight: FontWeight.bold,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Directionality(
                                                textDirection: textDirection,
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Column(
                                                          children: [
                                                            RoundedButtonBlue(
                                                              text: "Clear",
                                                              isOutlined: true,
                                                              isborderButton: true,
                                                              focusNode: clearBtnFocusNode,
                                                              press: () async {
                                                                FocusScope.of(context).requestFocus(clearBtnFocusNode);
                                                                inactivityTimerManager?.stopTimer();
                                                                bool? removeDialog = await DialogUtils.commonDialogforWarning(context, (pickType == "G") ? "Clear group list" : (pickType == "U") ? "Clear ULD list" : "Clear Trolley list", (pickType == "G") ? "Are you sure you want to clear group list ?" : (pickType == "U") ? "Are you sure you want to clear ULD list ?" : "Are you sure you want to clear Trolley list ?" , lableModel);

                                                                if(removeDialog == true){
                                                                  groupIdController.clear();
                                                                  pickType = "";
                                                                  dropLocationType = "";
                                                                  dropLocation = "";
                                                                  selectedType = "G";
                                                                  _isSelectAll = false;
                                                                  getGroupDetailList!.clear();
                                                                  getULDTrolleyDetailsList!.clear();
                                                                  addShipmentComplete = false;
                                                                  uldTrolleyForDrop = null;
                                                                  // Clear all switch states
                                                                  groupSwitchStates.clear();
                                                                  uldTrolleySwitchStates.clear();


                                                                  // Reset UI
                                                                  setState(() {});
                                                                }else{
                                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                                                  });
                                                                }

                                                                setState(() {});
                                                              },
                                                            ),
                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Switch(
                                                                  value: _isSelectAll,
                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  activeColor: MyColor.primaryColorblue,
                                                                  inactiveThumbColor: MyColor.thumbColor,
                                                                  inactiveTrackColor: MyColor.textColorGrey2,
                                                                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                  onChanged: (value) => toggleSelectAll(value),
                                                                ),
                                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                CustomeText(
                                                                    text: "Select All",
                                                                    fontColor: MyColor.textColorGrey2,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                    fontWeight: FontWeight.w500,
                                                                    textAlign: TextAlign.start),


                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                      Expanded(
                                                        flex:1,
                                                        child: Container(
                                                          height: double.infinity,
                                                          child: RoundedButton(
                                                            color:  MyColor.primaryColorblue,
                                                            focusNode: moveBtnFocusNode,
                                                            text: "${lableModel.move}",
                                                            press: () async {
                                                              FocusScope.of(context).requestFocus(moveBtnFocusNode);
                                                              inactivityTimerManager?.stopTimer();
                                                              if(dropLocation.isNotEmpty){
                                                                if(dropLocationType == "G"){
                                                                  if(pickType == "G"){
                                                                    moveLocation();
                                                                    //call move serch api data will be selected group
                                                                  }else{
                                                                    moveLocation();
                                                                    //call move serch api data will be selected uld/trolley
                                                                  }
                                                                }
                                                                else{



                                                                  List<GroupDetailList> selectedGroups = getSelectedGroupIds();
                                                                  int processedCount = 0;

                                                                  if(selectedGroups.length != 1){


                                                                    String warningMessage = selectedGroups.isEmpty
                                                                        ? "Please select 1 group."
                                                                        : "You can only select 1 group at a time.";

                                                                    // Display the warning message (you can use any method depending on your UI framework)
                                                                    Vibration.vibrate(duration: 500);
                                                                    SnackbarUtil.showSnackbar(context, warningMessage, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                                                  }
                                                                  else{
                                                                    for (var selectedGroup in selectedGroups) {
                                                                      addShipment(
                                                                        selectedGroup.aWBPrefix!,
                                                                        selectedGroup.aWBNo!,
                                                                        selectedGroup.eXPAWBRowId!,
                                                                        selectedGroup.eXPShipRowId!,
                                                                        selectedGroup.nOP!,
                                                                        selectedGroup.weight!,
                                                                        selectedGroup.groupSeqNo!,
                                                                        destinationWarningInd,
                                                                        shcCompibilityWarningInd,
                                                                      );

                                                                      processedCount++;
                                                                      if (processedCount == selectedGroups.length) {
                                                                        // All items have been processed

                                                                        addShipmentComplete = true;
                                                                        setState(() {

                                                                        });

                                                                        print("All selected groups processed successfully.");
                                                                      }
                                                                    }


                                                                  }



                                                                  // call add shipment api
                                                                }
                                                              }else{
                                                                SnackbarUtil.showSnackbar(context, "Please location search", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                Vibration.vibrate(duration: 500);
                                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                  FocusScope.of(context).requestFocus(groupIdFocusNode);
                                                                });
                                                                groupIdController.clear();
                                                              }

                                                              /*if (selectedValues.isEmpty) {
                                                                print("No items selected");
                                                                return;
                                                              }
                                                              String xmlData = generateImageXMLData(selectedValues);
                                                              print("Generated XML:$xmlData");*/

                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical),

                                        Directionality(textDirection: textDirection,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: MyColor.colorWhite,
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: MyColor.colorBlack.withOpacity(0.09),
                                                    spreadRadius: 2,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: (pickType == "G")
                                                  ? Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                child: (getGroupDetailList!.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (getGroupDetailList!.isNotEmpty) ?  getGroupDetailList!.length : 0,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        GroupDetailList groupDetailView = getGroupDetailList![index];

                                                        return InkWell(
                                                            onTap: () {
                                                              FocusScope.of(context).unfocus();

                                                            },
                                                            onDoubleTap: () async {



                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets.symmetric(vertical: 4),
                                                                decoration: BoxDecoration(
                                                                  color: MyColor.colorWhite,
                                                                  borderRadius: BorderRadius.circular(8),

                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: MyColor.colorBlack.withOpacity(0.09),
                                                                      spreadRadius: 2,
                                                                      blurRadius: 15,
                                                                      offset: Offset(0, 3), // changes position of shadow
                                                                    ),
                                                                  ],

                                                                ),
                                                                child: Container(
                                                                  padding: EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                    color: MyColor.colorWhite,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Switch(
                                                                                value: groupSwitchStates[groupDetailView]!,
                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                activeColor: MyColor.primaryColorblue,
                                                                                inactiveThumbColor: MyColor.thumbColor,
                                                                                inactiveTrackColor: MyColor.textColorGrey2,
                                                                                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                                onChanged:  (value) => toggleGroupSwitch(groupDetailView, value),
                                                                              ),
                                                                              SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                              CustomeText(
                                                                                text: AwbFormateNumberUtils.formatAWBNumber("${groupDetailView.aWBPrefix}${groupDetailView.aWBNo}"),
                                                                                fontColor: MyColor.textColorGrey3,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                fontWeight: FontWeight.w600,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${lableModel.pieces} :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${groupDetailView.nOP}",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${lableModel.weight} :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${CommonUtils.formateToTwoDecimalPlacesValue(groupDetailView.weight!)} Kg",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical),
                                                                          IntrinsicHeight(
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 6,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          CustomeText(
                                                                                            text: "${lableModel.group} :",
                                                                                            fontColor: Colors.pink.shade500,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(width: 5),
                                                                                          CustomeText(
                                                                                            text: "${groupDetailView.groupId}",
                                                                                            fontColor: Colors.pink.shade500,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: SizeConfig.blockSizeVertical),
                                                                                      Row(
                                                                                        children: [
                                                                                          CustomeText(
                                                                                            text: "${lableModel.currentLocation} :",
                                                                                            fontColor: MyColor.textColorGrey2,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(width: 5),
                                                                                          CustomeText(
                                                                                            text: "${groupDetailView.curentLocation}",
                                                                                            fontColor: MyColor.colorBlack,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: RoundedButton(text: "Remove",
                                                                                    color: MyColor.colorRed,
                                                                                    focusNode: removeGroupBtnFocusNode,
                                                                                    press: () async {
                                                                                      FocusScope.of(context).requestFocus(removeGroupBtnFocusNode);
                                                                                      inactivityTimerManager?.stopTimer();
                                                                                      bool? removeDialog = await DialogUtils.commonDialogforWarning(context, "${lableModel.remove}", (pickType == "G") ? "Are you sure you want to remove this group ?" : (pickType == "U") ? "Are you sure you want to remove this ULD ?" : "Are you sure you want to remove this Trolley ?" , lableModel);

                                                                                      if(removeDialog == true){
                                                                                        groupSelectIndex = index;
                                                                                        removeMovement(groupDetailView.groupSeqNo!, pickType);

                                                                                      }else{
                                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                          FocusScope.of(context).requestFocus(groupIdFocusNode);
                                                                                        });
                                                                                      }

                                                                                    },),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel.recordNotFound}",
                                                        fontColor: MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
                                                ),

                                              )
                                                  : Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                child: (getULDTrolleyDetailsList!.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: getULDTrolleyDetailsList!.length,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        ULDTrolleyDetailsList uldTrolleyDetailView = getULDTrolleyDetailsList![index];

                                                        return InkWell(
                                                            onTap: () {
                                                              FocusScope.of(context).unfocus();
                                                            },
                                                            onDoubleTap: () async {

                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets.symmetric(vertical: 4),
                                                                decoration: BoxDecoration(
                                                                  color: MyColor.colorWhite,
                                                                  borderRadius: BorderRadius.circular(8),

                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: MyColor.colorBlack.withOpacity(0.09),
                                                                      spreadRadius: 2,
                                                                      blurRadius: 15,
                                                                      offset: Offset(0, 3), // changes position of shadow
                                                                    ),
                                                                  ],

                                                                ),
                                                                child: Container(
                                                                  padding: EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                    color: MyColor.colorWhite,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Switch(
                                                                                    value: uldTrolleySwitchStates[uldTrolleyDetailView]!,
                                                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                    activeColor: MyColor.primaryColorblue,
                                                                                    inactiveThumbColor: MyColor.thumbColor,
                                                                                    inactiveTrackColor: MyColor.textColorGrey2,
                                                                                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                                    onChanged:  (value) => toggleTrolleySwitch(uldTrolleyDetailView, value),
                                                                                  ),
                                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                                  ULDNumberWidget(uldNo: "${uldTrolleyDetailView.uLDTrolleyType} ${uldTrolleyDetailView.uLDTrolleyNo} ${uldTrolleyDetailView.uLDOwner}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: selectedType),

                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  CustomeText(
                                                                                    text: "${lableModel.status} : ",
                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal),
                                                                                  Container(
                                                                                    padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                                                    decoration : BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                        color: (uldTrolleyDetailView.uLDTrolleyStatus == "O" || uldTrolleyDetailView.uLDTrolleyStatus == "R") ? MyColor.flightFinalize :MyColor.flightNotArrived
                                                                                    ),
                                                                                    child: CustomeText(
                                                                                      text: (uldTrolleyDetailView.uLDTrolleyStatus == "O" || uldTrolleyDetailView.uLDTrolleyStatus == "R") ? "Open" : "Closed",
                                                                                      fontColor: MyColor.textColorGrey3,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${lableModel.scaleWt} :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${CommonUtils.formateToTwoDecimalPlacesValue(uldTrolleyDetailView.scaleWeight!)} Kg",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${lableModel.offPoint} :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: uldTrolleyDetailView.offPoint!,
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical),
                                                                          IntrinsicHeight(
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 6,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [

                                                                                      Row(
                                                                                        children: [
                                                                                          CustomeText(
                                                                                            text: "${lableModel.currentLocation} :",
                                                                                            fontColor: MyColor.textColorGrey2,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(width: 5),
                                                                                          CustomeText(
                                                                                            text: "${uldTrolleyDetailView.curentLocation}",
                                                                                            fontColor: MyColor.colorBlack,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: RoundedButton(text: "Remove",
                                                                                    color: MyColor.colorRed,
                                                                                    focusNode: removeULDTrolleyBtnFocusNode,
                                                                                    press: () async {
                                                                                      FocusScope.of(context).requestFocus(removeULDTrolleyBtnFocusNode);
                                                                                      inactivityTimerManager?.stopTimer();
                                                                                      bool? removeDialog = await DialogUtils.commonDialogforWarning(context, "${lableModel.remove}", (pickType == "G") ? "Are you sure you want to remove this group ?" : (pickType == "U") ? "Are you sure you want to remove this ULD ?" : "Are you sure you want to remove this Trolley ?" , lableModel);
                                                                                      if(removeDialog == true){
                                                                                        uldTrolleySelectIndex = index;
                                                                                        removeMovement(uldTrolleyDetailView.uLDTrolleySeqNo!, pickType);



                                                                                       /* ULDTrolleyDetailsList removedGroup = getULDTrolleyDetailsList!.removeAt(index);
                                                                                        // Remove the corresponding entry from the switch states
                                                                                        uldTrolleySwitchStates.remove(removedGroup);

                                                                                        setState(() {

                                                                                        });*/
                                                                                      }else{
                                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                          FocusScope.of(context).requestFocus(groupIdFocusNode);
                                                                                        });
                                                                                      }

                                                                                    },),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel.recordNotFound}",
                                                        fontColor: MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
                                                ),

                                              )
                                            )),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Directionality(
                                textDirection: uiDirection,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      // Yes Option
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            if (pickType == "G" || pickType == "" || pickType == "U") {
                                              setState(() {
                                                selectedType = "U";
                                              });

                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              groupIdController.clear();
                                            }



                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "U" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: lableModel.uldLable!.toUpperCase(), fontColor: selectedType == "U" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),
                                      // No Option
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            if (pickType == "G" || pickType == "") {
                                              setState(() {
                                                selectedType = "G";
                                              });
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              groupIdController.clear();
                                            }


                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "G" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: lableModel.group!.toUpperCase(), fontColor: selectedType == "G" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            if (pickType == "G" || pickType == "" || pickType == "T") {
                                              setState(() {
                                                selectedType = "T";
                                              });

                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              groupIdController.clear();
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "T" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: "TROLLEY", fontColor: selectedType == "T" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanGroupQR() async{
    String groupcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(groupcodeScanResult == "-1"){

    }else{
      bool specialCharAllow = CommonUtils.containsSpecialCharacters(groupcodeScanResult);

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        groupIdController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });
      }else{

        String result = groupcodeScanResult.replaceAll(" ", "");
        String truncatedResult = "";
        if(selectedType == "G"){
          truncatedResult = result.length > 14
              ? result.substring(0, 14)
              : result;
        }else if(selectedType == "U"){
          truncatedResult = result.length > 11
              ? result.substring(0, 11)
              : result;
        }else{
          truncatedResult = result.length > 20
              ? result.substring(0, 20)
              : result;
        }



        groupIdController.text = truncatedResult;

        getMoveSearch();

        // Call searchLocation api to validate or not
        // call binning details api

        /* await context.read<BinningCubit>().getBinningDetailListApi(
              groupIdController.text,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId);*/


      }

    }


  }

  Future<void> getMoveSearch() async {

    print("moveLocation Payload === ${pickType} == ${dropLocation}");


    await context.read<MoveCubit>().getMoveSearch(
        groupIdController.text,
        selectedType,
        (selectedType == "G") ? getGroupDetailList!.length : getULDTrolleyDetailsList!.length,
        pickType,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> moveLocation() async {

    print("CHECK_LOCATION === ${pickType} == ${dropLocation} == ${selectedType} == ${generateImageXMLDataGroup(getSelectedGroupIds())} == ${generateImageXMLDataULDTrolley(getSelectedTrolleyIds())}" );


    await context.read<MoveCubit>().moveLocation(
        pickType,
        dropLocation,
        (selectedType == "G") ? generateImageXMLDataGroup(getSelectedGroupIds()) : generateImageXMLDataULDTrolley(getSelectedTrolleyIds()),
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }


  Future<void> removeMovement(int seqNo, String type) async {


    await context.read<MoveCubit>().removeMovement(
        seqNo,
        type,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }


  String generateImageXMLDataGroup(List<GroupDetailList> selectList) {
    StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.write('<Root>');
    for (GroupDetailList value in selectList) {
      xmlBuffer.write('<Move>');
      xmlBuffer.write('<SeqNo>${value.groupSeqNo}</SeqNo>');
      xmlBuffer.write('</Move>');
    }
    xmlBuffer.write('</Root>');
    return xmlBuffer.toString();
  }

  String generateImageXMLDataULDTrolley(List<ULDTrolleyDetailsList> selectList) {
    StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.write('<Root>');
    for (ULDTrolleyDetailsList value in selectList) {
      xmlBuffer.write('<Move>');
      xmlBuffer.write('<SeqNo>${value.uLDTrolleySeqNo}</SeqNo>');
      xmlBuffer.write('</Move>');
    }
    xmlBuffer.write('</Root>');
    return xmlBuffer.toString();
  }

  List<GroupDetailList> getSelectedGroupIds() {
    return groupSwitchStates.entries
        .where((entry) => entry.value) // Only include selected items
        .map((entry) => entry.key) // Return their IDs
        .toList();
  }

  List<ULDTrolleyDetailsList> getSelectedTrolleyIds() {
    return uldTrolleySwitchStates.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  Future<void> addShipment(String awbPrefix, String awbNumber, int awbRowId, int awbShipRowId, int nop, double weight, int groupSeqNo, String warningInd, String shcWarning) async {

    print("AWB NO ==== > ${awbPrefix} == ${awbNumber} == ${groupSeqNo}");

    await context.read<MoveCubit>().addShipment(
        uldTrolleyForDrop!.flightSeqNo!,
        awbRowId, awbShipRowId, uldTrolleyForDrop!.uLDTrolleySeqNo!,
        awbPrefix , awbNumber.replaceAll(" ", ""), nop, weight,
        uldTrolleyForDrop!.offPoint!, uldTrolleyForDrop!.sHCCode!,
        "N", uldTrolleyForDrop!.sHCCode!.contains("DGR") ? "Y" : "N",
        dropLocationType,
        "", 0, "", groupSeqNo, warningInd, shcWarning,
        uldTrolleyForDrop!.carriarCode!,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }



}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

