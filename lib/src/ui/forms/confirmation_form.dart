import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationForm {
  static showModalBottomDialog(context, List<FormItem> formItems,
      ModuleItem moduleItem, List<Map<String?, dynamic>> input) {
    final formKey = GlobalKey<FormState>();

    return Get.bottomSheet(
        Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Confirm Transaction",
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.back(result: 1);
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
                const Spacer(),
                WidgetFactory.buildButton(context, () {
                  Get.back(result: 0);
                }, "Confirm")
              ],
            )),
        backgroundColor: Colors.white);
  }
}
