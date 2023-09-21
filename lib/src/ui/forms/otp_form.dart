import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_postcall.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:vibration/vibration.dart';

class OTPForm {
  static confirmOTPTransaction(
      context, ModuleItem moduleItem, PreCallData? preCallData) {
    return showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => ModalBottomSheet(
        moduleItem: moduleItem,
        preCallData: preCallData,
      ),
    );
  }
}

class ModalBottomSheet extends StatefulWidget {
  ModalBottomSheet({super.key, required this.moduleItem, this.preCallData});

  final ModuleItem moduleItem;
  PreCallData? preCallData;

  @override
  State<StatefulWidget> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  static final formKey = GlobalKey<FormState>();
  static final _services = APIService();
  static final otpController = TextEditingController();
  static bool isLoading = false;

  @override
  void initState() {
    super.initState();
    otpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            opacity: .1,
            image: AssetImage(
              'assets/launcher/launcher.png',
            ),
          )),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
          child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(1);
                    },
                    child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.close), Text("Cancel")]),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Enter OTP sent via sms/email to proceed with transaction",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  obscureText: true,
                  autofocus: true,
                  defaultPinTheme: PinTheme(
                      height: 44,
                      width: 44,
                      padding: const EdgeInsets.all(4),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: APIService.appPrimaryColor))),
                  controller: otpController,
                  onCompleted: (pin) {},
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                isLoading
                    ? LoadUtil()
                    : SizedBox(
                        width: 300,
                        child: WidgetFactory.buildButton(context, () {
                          confirmTransactionVerification(
                              widget.moduleItem, widget.preCallData, context);
                        }, "CONFIRM TRANSACTION",
                            color: APIService.appPrimaryColor)),
              ])),
        ));
  }

  confirmTransactionVerification(ModuleItem moduleItem,
      PreCallData? preCallData, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (otpController.text.isNotEmpty) {
        if (otpController.text.length == 6) {
          if (preCallData != null) {
            setState(() {
              isLoading = true;
            });
            var obj = preCallData.requestObject;
            obj?["EncryptedFields"]
                .addAll({"TrxOTP": CryptLib.encryptField(otpController.text)});
            _services
                .dynamicRequest(
                    formID: preCallData.formID,
                    requestObj: obj,
                    webHeader: preCallData.webheader)
                .then((value) {
              setState(() {
                otpController.clear();
                isLoading = false;
              });
              if (value.status == StatusCode.otp.statusCode) {
                CommonUtils.showToast("Verification failed!");
                return;
              } else {
                DynamicPostCall.processDynamicResponse(
                    value.dynamicData, context, null,
                    moduleItem: moduleItem);
              }
            });
          }
        } else {
          Vibration.vibrate();
          CommonUtils.showToast("Invalid OTP!");
        }
      } else {
        Vibration.vibrate();
        CommonUtils.showToast("Please enter OTP!");
      }
    }
  }
}
