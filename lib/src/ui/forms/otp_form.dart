import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTPForm {
  static final _dynamicReq = DynamicFormRequest();

  static showModalBottomDialog(context, List<FormItem> formItems,
      ModuleItem moduleItem, List<Map<String?, dynamic>> input) async {
    final formKey = GlobalKey<FormState>();
    final _otpController = TextEditingController();

    Get.bottomSheet(
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              opacity: .1,
              image: AssetImage(
                'assets/launcher/launcher.png',
              ),
            )),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
            child: Column(children: [
              Row(
                children: [
                  const Text(
                    "Verify OTP received",
                    style: TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(1);
                    },
                    child: const Row(
                        children: [Icon(Icons.close), Text("Cancel")]),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Form(
                  key: formKey,
                  child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      children: [
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
                                  border: Border.all(
                                      color: APIService.appPrimaryColor))),
                          controller: _otpController,
                          onCompleted: (pin) {},
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FractionallySizedBox(
                            widthFactor:
                                1, // Set the fraction to limit the width (e.g., 0.8 means 80% of the available width)
                            child: WidgetFactory.buildButton(context, () {
                              confirmTransaction(moduleItem);
                            }, "CONFIRM TRANSACTION",
                                color: APIService.appPrimaryColor)),
                      ])),
            ])),
        backgroundColor: Colors.white);
  }

  static confirmTransaction(ModuleItem moduleItem) async {
    _dynamicReq.dynamicRequest(moduleItem);
  }
}
