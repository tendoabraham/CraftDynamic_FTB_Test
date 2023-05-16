part of craft_dynamic;

class CommonUtils {
  static var snackBarDuration = const Duration(seconds: 6);
  static const snackBarBehavior = SnackBarBehavior.fixed;
  static var errorColor = Colors.red;
  static var successColor = Colors.green[600];

  static Future<void> selectDate(BuildContext context, {refreshDate}) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      refreshDate(true, newText: selectedDate);
    }
  }

  static Future<void> openUrl(Uri url, {context}) async {
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      AppLogger.appLogE(tag: "url launch error", message: e.toString());
      buildErrorSnackBar(context: context, message: "Could not launch url");
      Navigator.pop(context);
    }
  }

  static buildErrorSnackBar({context, message}) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: snackBarDuration,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(message)
              ],
            ),
            behavior: snackBarBehavior,
            backgroundColor: errorColor),
      );
    } catch (e) {
      AppLogger.appLogE(tag: "snackbar error", message: e.toString());
    }
  }

  static navigateToRoute({required context, required widget}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static navigateToRouteAndPopAll({required context, required widget}) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static getXRouteAndPopAll({required widget}) {
    Get.offAll(widget);
  }

  static getxPop({required widget}) {
    Get.off(widget);
  }

  static getxNavigate({required widget}) {
    Get.to(widget);
  }

  static showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static vibrate() {
    if (!kIsWeb) {
      Vibration.vibrate();
    }
  }
}
