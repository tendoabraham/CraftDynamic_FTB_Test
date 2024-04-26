part of craft_dynamic;

class AlertUtil {
  static showAlertDialog(BuildContext context, String message,
      {isConfirm = false,
        isInfoAlert = false,
        showTitleIcon = true,
        formFields,
        title,
        confirmButtonText = "Ok",
        cancelButtonText = "Cancel"}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      pageBuilder: (BuildContext context, anim1, anim2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: AlertDialog(
                  title: const Text(
                    "Error!",
                    style: TextStyle(
                        fontFamily: "Myriad Pro", fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    message,
                    style: TextStyle(
                      fontFamily: "Myriad Pro",
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        "OK",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
            ));
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static showModalBottomDialog(context, message) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding:
            const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: ListView(
              shrinkWrap: true,
              children: [
                DynamicTextViewWidget(jsonText: message).render(),
                WidgetFactory.buildButton(context, () {
                  Navigator.of(context).pop();
                }, "Done")
              ],
            ));
      },
    );
  }
}
