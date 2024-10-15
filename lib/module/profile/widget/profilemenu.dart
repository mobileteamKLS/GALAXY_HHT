import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfileMenu extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? press;
  Color? iconColor;
  double? textSize;

  ProfileMenu({super.key, required this.text, required this.icon, this.press, this.iconColor, required this.textSize});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: press,
      child: Row(
        children: [
          Icon(icon, color: (iconColor == null) ? const Color(0xff35438e) : iconColor,),
          const SizedBox(width: 20),
          Expanded(child: Text(text, style: GoogleFonts.poppins(textStyle: TextStyle(color: (iconColor == null) ? const Color(0xff35438e) : iconColor, fontWeight: FontWeight.w500, fontSize: textSize),))),
        ],
      ),
    );
  }
}
