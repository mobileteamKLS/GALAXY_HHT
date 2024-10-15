import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/widget/custometext.dart';

import '../../language/appLocalizations.dart';
import '../../language/model/lableModel.dart';
import '../../module/import/model/uldacceptance/ulddamgeupdatemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../customdivider.dart';
import 'header.dart';

class EnlargedBinaryImageScreen extends StatefulWidget {
  final String binaryFile;
  final List<String> imageList;
  final int index;

  EnlargedBinaryImageScreen({super.key, required this.binaryFile, required this.imageList, required this.index});

  @override
  State<EnlargedBinaryImageScreen> createState() =>
      _EnlargedBinaryImageScreenState();
}

class _EnlargedBinaryImageScreenState extends State<EnlargedBinaryImageScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index!);
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.colorWhite,
        body: Column(
          children: [
            HeaderWidget(
              title:lableModel!.imagePreview!,
              onBack: () {
                Navigator.pop(context);
              },
              clearText: "",
            ),
            CustomDivider(
              space: 0,
              color: Colors.black,
              hascolor: true,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageList.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Hero(
                      tag: widget.imageList[index],
                      child: InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: Image.memory(
                          base64Decode(widget.imageList[index]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )

        /*Center(
          child: InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Image.memory(
              widget.binaryFile,
              fit: BoxFit.contain,
            ),
          ),
        ),*/
      ),
    );
  }
}
