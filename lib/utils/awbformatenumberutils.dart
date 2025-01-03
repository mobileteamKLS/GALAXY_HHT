class AwbFormateNumberUtils{
  static String formatAWBNumber(String awbNumber) {

    String cleanedAwbno = awbNumber.replaceAll(RegExp(r'[\s-]'), '');

    String awbNo = cleanedAwbno.replaceAll(" ", "");

    if (awbNo.length == 11) {
      // Format the number as 115-7988 3754
      return '${awbNo.substring(0, 3)}-${awbNo.substring(3, 7)} ${awbNo.substring(7)}';
    }
    // Return the original number if it doesn't match the expected length
    return awbNo;
  }
}