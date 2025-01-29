import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/modal/forwardForExam.dart';
import 'package:galaxy/Ipad/utils/global.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/commonutils.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../utils/flightnumbervalidationutils.dart';
import '../../utils/sizeutils.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../modal/VehicleTrack.dart';

class CustomeEditTextWithBorderDatePicker extends StatefulWidget {
  final String lablekey;
  final String? labelText;
  final IconData? prefixicon;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool isEnable;
  final TextInputAction inputAction;
  final double fontSize;
  final Color fillColor;
  final Color fontColor;
  final Color? prefixIconcolor;
  final double verticalPadding;
  final double circularCorner;
  final int? maxLength;


  const CustomeEditTextWithBorderDatePicker({
    Key? key,
    required this.lablekey,
    this.labelText,
    this.hintText,
    this.prefixicon,
    this.controller,
    this.focusNode,
    this.readOnly = true, // Make it read-only since it's for date input only
    this.isEnable = true,
    this.inputAction = TextInputAction.next,
    this.fontSize = 10,
    this.fillColor = Colors.transparent,
    this.fontColor = Colors.black,
    this.prefixIconcolor,
    this.verticalPadding = 0,
    this.circularCorner = 6,
    this.maxLength = 13,

  }) : super(key: key);

  @override
  State<CustomeEditTextWithBorderDatePicker> createState() => _CustomeEditTextWithBorderDatePickerState();
}

class _CustomeEditTextWithBorderDatePickerState extends State<CustomeEditTextWithBorderDatePicker> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && widget.controller != null) {
      widget.controller!.text = dateFormat.format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.controller,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          color: widget.fontColor,
          fontSize: widget.fontSize,
        ),
      ),
      cursorColor: MyColor.primaryColorblue,
      textInputAction: widget.inputAction,
      decoration: InputDecoration(
        prefixIcon: widget.prefixicon != null
            ? Icon(
          widget.prefixicon,
          color: widget.prefixIconcolor,
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        labelText: widget.labelText ?? '',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: widget.fontColor,
            fontSize: widget.fontSize,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.circularCorner),
          borderSide: const BorderSide(color:MyColor.borderColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.circularCorner),
          borderSide: const BorderSide(color:MyColor.borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.circularCorner),
          borderSide: const BorderSide(color:MyColor.borderColor, width: 0.5),
        ),

        suffixIcon: IconButton(
          onPressed: () {
            print("Date picker");
            _pickDate();
          } ,
          icon: const Icon(Icons.calendar_today, color: MyColor.primaryColorblue),
        ),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget targetPage;
  final Color containerColor;
  final Color iconColor;
  final Color textColor;

  const RoundedIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.targetPage,
    this.containerColor = Colors.blue,
    this.iconColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        width: MediaQuery.sizeOf(context).width*0.29,
        height:MediaQuery.sizeOf(context).height*0.22 ,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(
                  0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 64,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        )
      ),
    );
  }
}
class RoundedIconButtonNew extends StatelessWidget {
  final String icon;
  final String text;
  final Widget targetPage;
  final Color containerColor;
  final Color iconColor;
  final Color textColor;

  const RoundedIconButtonNew({
    Key? key,
    required this.icon,
    required this.text,
    required this.targetPage,
    this.containerColor = Colors.blue,
    this.iconColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        width: MediaQuery.sizeOf(context).width*0.29,
        height:MediaQuery.sizeOf(context).height*0.22 ,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(
                  0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child:Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: containerColor,
              ),
              child: SvgPicture.asset(
                icon,

                height: 64,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 24,fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        )
      ),
    );
  }
}

class CommodityService {
  static List<Commodity> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return commodityListMaster.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.commodityType);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return commodityListMaster.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.commodityType);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}
class AgentService {
  static List<Customer> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return customerListMaster.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.customerName);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return customerListMaster.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.customerName);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}
class OriginAndDestinationService {
  static List<OriginDestination> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return originDestinationMaster.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.airportCodeI313);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return originDestinationMaster.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.airportCodeI313);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}
class FirmsCodeService {
  static List<FrmAndDcpCode> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return firmsCodeMaster.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.referenceDataIdentifier);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return firmsCodeMaster.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.referenceDataIdentifier);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}
class DispositionCodeService {
  static List<FrmAndDcpCode> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return dispositionCodeMaster.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.referenceDataIdentifier);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return dispositionCodeMaster.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.referenceDataIdentifier);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}
class DoorService {
  static List<Door> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return doorList.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.door);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return doorList.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.door);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}

class RemarksService {
  static List<RemarksData> find(String search) {
    String normalizedSearch = normalizeStringSearch(search);
    print("____$normalizedSearch");
    return remarksList.where((agent) {
      String normalizedAgentName =  normalizeStringSearch(agent.description);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeStringValid(input);
    return remarksList.any((agent) {
      String normalizedAgentName = normalizeStringValid(agent.description);
      return normalizedAgentName == normalizedInput;
    });
  }
  static String normalizeStringSearch(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeStringValid(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
  }
}




