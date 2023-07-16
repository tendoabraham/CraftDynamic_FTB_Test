import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';

class ConfirmationForm {
  static confirmTransaction(context, List<FormItem> formItems,
      ModuleItem moduleItem, Map<String?, dynamic> input) {
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet<void>(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                const Spacer(),
                WidgetFactory.buildButton(context, () {
                  Navigator.of(context).pop(0);
                }, "Confirm")
              ],
            ));
      },
    );
  }
}
