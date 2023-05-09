part of craft_dynamic;

class AlertUtil {
  static showAlertDialog(BuildContext context, String message,
      {isConfirm = false, isInfoAlert = false, formFields}) {
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
                insetPadding: const EdgeInsets.symmetric(horizontal: 34),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                title: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isInfoAlert
                        ? Lottie.asset(
                            "packages/craft_dynamic/assets/lottie/info_lottie.json")
                        : Lottie.asset(
                            "packages/craft_dynamic/assets/lottie/error.json",
                            height: 88,
                            width: 88)
                  ],
                )),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: ListBody(
                      children: <Widget>[
                        Center(
                            child: Text(
                          message,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ))),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: isConfirm
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      isConfirm
                          ? Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text("cancel").tr()),
                                const SizedBox(
                                  width: 12,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Align(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("ok").tr())),
                    ],
                  )
                ],
              ),
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
