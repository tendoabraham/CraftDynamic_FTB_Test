import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPForm {
  static showModalBottomDialog(context, List<FormItem> formItems,
      ModuleItem moduleItem, List<Map<String?, dynamic>> input) async {
    final formKey = GlobalKey<FormState>();

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
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: formItems.length,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemBuilder: (context, index) {
                        return BaseFormComponent(
                            formItem: formItems[index],
                            moduleItem: moduleItem,
                            formItems: formItems,
                            formKey: formKey,
                            child:
                                IFormWidget(formItems[index], jsonText: input)
                                    .render());
                      })),
            ])),
        backgroundColor: Colors.white);
  }
}
