import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/widget/custometext.dart';

import '../../language/appLocalizations.dart';
import '../../language/model/lableModel.dart';
import '../../module/import/model/uldacceptance/ulddamgeupdatemodel.dart';
import '../../module/onboarding/sizeconfig.dart';

class EnlargedFileImageScreen extends StatefulWidget {
  final List<File>? imageList;
  final int? initialIndex;
  final File? imageFile;

  EnlargedFileImageScreen({super.key, this.imageFile, this.imageList, this.initialIndex});

  @override
  State<EnlargedFileImageScreen> createState() => _EnlargedFileImageScreenState();
}

class _EnlargedFileImageScreenState extends State<EnlargedFileImageScreen> {

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex!);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    AppLocalizations? localizations = AppLocalizations.of(context);
    LableModel? lableModel = localizations!.lableModel;

    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: AppBar(


        backgroundColor: MyColor.colorWhite,
        title: CustomeText(text: lableModel!.imagePreview!, fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * 1.9, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageList!.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: widget.imageList![index].path,
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.file(
                  widget.imageList![index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
