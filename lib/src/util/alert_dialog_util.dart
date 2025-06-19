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
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 12,
                  backgroundColor: Colors.white,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header with icon and gradient background
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, Color(0xFF1A68C0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.white, size: 26),
                              SizedBox(width: 8),
                              Text(
                                "Alert",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontFamily: "Myriad Pro",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 24),
                          child: Text(
                            message,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Myriad Pro",
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        // Action Button
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 200, right: 20, bottom: 20),
                          child: SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: APIService.appSecondaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "OK",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Myriad Pro",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                // AlertDialog(
                //   title: Text(
                //     "Error!",
                //     style: TextStyle(
                //         fontFamily: "Myriad Pro", fontWeight: FontWeight.bold),
                //   ),
                //   content: Text(
                //     message,
                //     style: TextStyle(
                //       fontFamily: "Myriad Pro",
                //     ),
                //   ),
                //   actions: <Widget>[
                //     TextButton(
                //       child: Text(
                //         "OK",
                //         style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Myriad Pro", fontSize: 18, color: APIService.appSecondaryColor),
                //       ),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ],
                // )
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
