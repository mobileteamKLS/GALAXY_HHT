import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/language/model/dashboardModel.dart';
import 'package:galaxy/module/login/pages/loginscreen.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/widget/customdivider.dart';
import 'package:galaxy/widget/customeuiwidgets/header.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mycolor.dart';
import '../../../language/appLocalizations.dart';
import '../../../prefrence/savedprefrence.dart';
import '../../../utils/dialogutils.dart';
import '../../../widget/customeuiwidgets/footer.dart';
import '../../login/pages/signinscreenmethods.dart';
import '../../onboarding/sizeconfig.dart';
import '../../login/model/userlogindatamodel.dart';
import '../widget/profilemenu.dart';
import 'dart:ui' as ui;

class Profilepagescreen extends StatefulWidget {
  const Profilepagescreen({super.key});

  @override
  State<Profilepagescreen> createState() => _ProfilepagescreenState();
}

class _ProfilepagescreenState extends State<Profilepagescreen> {

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userName = await savedPrefrence.getUserData();
    if (userName != null) {
      setState(() {
        _user = userName;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    AppLocalizations? localizations = AppLocalizations.of(context);
    DashboardModel? dashboardModel = localizations!.dashboardModel;
    ui.TextDirection uiDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.ltr
        : ui.TextDirection.ltr;

    ui.TextDirection textDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;

    return Directionality(
      textDirection: uiDirection,
      child: Scaffold(
        backgroundColor: MyColor.colorWhite,
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidget(title: "${dashboardModel!.profile}", onBack:() {
                Navigator.pop(context);
              },),
              CustomDivider(space: 0, color: Colors.black, hascolor: true,),
              Container(
                margin: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal * 3, right :SizeConfig.blockSizeHorizontal * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.7,),
                    CircleAvatar(
                      radius: SizeConfig.blockSizeVertical * 4.5,
                      backgroundColor: MyColor.primaryColorblue,
                      child: Text("${_user!.userProfile!.firstName![0]}${_user!.userProfile!.lastName![0]}", style:  GoogleFonts.poppins(textStyle:TextStyle(fontSize: SizeConfig.textMultiplier * 3.5, color: MyColor.colorWhite)),),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.7,),

                    Text( "${_user?.userProfile?.firstName ?? ''} ${_user?.userProfile?.lastName ?? ''}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: SizeConfig.textMultiplier * 2, color: MyColor.colorBlack),)),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.3),
                    Divider(thickness: 0.2,),
                    Directionality(
                      textDirection: textDirection,
                      child: ProfileMenu(
                        iconColor: MyColor.primaryColorblue,
                        text: "${dashboardModel.feedback}",
                        icon: Icons.feedback_rounded,
                        textSize:  SizeConfig.textMultiplier * 1.5,
                        press: () {},
                      ),
                    ),
                    Directionality(
                      textDirection: textDirection,
                      child: ProfileMenu(
                        iconColor: MyColor.primaryColorblue,
                        text: "${dashboardModel.helpCenter}",
                        icon: Icons.help_outline_rounded,
                        textSize:  SizeConfig.textMultiplier * 1.5,
                        press: () {},
                      ),
                    ),
                    SizedBox(height:  SizeConfig.blockSizeVertical * 0.2),
                    Divider(thickness: 0.2,),
                    SizedBox(height:  SizeConfig.blockSizeVertical * 0.2),
                    Directionality(
                      textDirection: textDirection,
                      child: ProfileMenu(
                          text: "${dashboardModel.logout}",
                          icon: Icons.login_rounded,
                          iconColor: Colors.red,
                          textSize:  SizeConfig.textMultiplier * 1.5,
                          press: () async {

                            bool? logoutConfirmed = await DialogUtils.showLogoutDialog(context, dashboardModel);
                            if (logoutConfirmed == true) {
                              await savedPrefrence.logout();
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SignInScreenMethod(),
                                ), (route) => false,
                              );
                            }
                          }
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: FooterCompanyName(),
      ),
    );

  }
}
