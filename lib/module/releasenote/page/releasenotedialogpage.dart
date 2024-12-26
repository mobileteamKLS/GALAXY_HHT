import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/sizeutils.dart';

import '../../../widget/custometext.dart';
import '../model/releasenotemodel.dart';

class ReleaseNoteDialog extends StatefulWidget {
  final ReleaseNoteModel releaseNoteModel;

  ReleaseNoteDialog({required this.releaseNoteModel});

  @override
  State<ReleaseNoteDialog> createState() => _ReleaseNoteDialogState();
}

class _ReleaseNoteDialogState extends State<ReleaseNoteDialog> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height; // Limit height for non-expanded view
    return AlertDialog(
      backgroundColor: MyColor.colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Set custom corner radius
      ),
      title: CustomeText(
        text: "Release Notes",
        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
        textAlign: TextAlign.start,
        fontColor: MyColor.colorBlack,
        fontWeight: FontWeight.w600,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _isExpanded ? maxHeight * 0.62 : maxHeight * 0.6, // Toggle height
              child: ListView.builder(
                shrinkWrap: false,
                physics: _isExpanded
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: widget.releaseNoteModel.releaseNoteList?.length ?? 0,
                itemBuilder: (context, index) {
                  final releaseNote = widget.releaseNoteModel.releaseNoteList![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeText(
                        text: releaseNote.date!,
                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                        textAlign: TextAlign.start,
                        fontColor: MyColor.colorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      ...?releaseNote.notes?.map((note) => Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Row(
                          children: [
                            Text('- '),
                            Flexible(child: CustomeText(
                              text: note,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                              textAlign: TextAlign.start,
                              fontColor: MyColor.colorBlack,
                              fontWeight: FontWeight.w600,
                            )),
                          ],
                        ),
                      )),
                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                    ],
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded; // Toggle expanded state
                });
              },
              child: CustomeText(
                text: _isExpanded ? "Show Less" : "Show More",
                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                textAlign: TextAlign.center,
                fontColor: MyColor.primaryColorblue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: CustomeText(
            text: "Cancel",
            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
            textAlign: TextAlign.end,
            fontColor: MyColor.primaryColorblue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

  }
}
