// ignore_for_file: must_be_immutable

part of dynamic_widget;

class ModuleItemWidget extends StatelessWidget {
  bool isMain = false;
  bool isSearch;
  ModuleItem moduleItem;

  ModuleItemWidget(
      {Key? key,
      this.isMain = false,
      this.isSearch = false,
      required this.moduleItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          ModuleUtil.onItemClick(moduleItem, context);
        },
        child: Consumer<PluginState>(
            builder: (context, state, child) =>
                state.menuItem ??
                IMenuUtil(
                        Provider.of<PluginState>(context, listen: false)
                                .menuType ??
                            MenuType.DefaultMenuItem,
                        moduleItem)
                    .getMenuItem()));
    // child: IMenuUtil(
    //         Provider.of<PluginState>(context, listen: false).menuType ??
    //             MenuType.DefaultMenuItem,
    //         moduleItem)
    //     .getMenuItem());
  }
}

class VerticalModule extends StatelessWidget {
  ModuleItem moduleItem;
  bool hasBorder;

  VerticalModule({super.key, required this.moduleItem, this.hasBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: getMenuColor(context) ?? Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: hasBorder
                ? Border.all(width: 1, color: Colors.grey[400]!)
                : null),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MenuItemImage(
                imageUrl: moduleItem.moduleUrl ?? "",
              ),
              const SizedBox(
                height: 12,
              ),
              MenuItemTitle(title: moduleItem.moduleName)
            ],
          ),
        ));
  }

  Color? getMenuColor(context) =>
      Provider.of<PluginState>(context, listen: false).menuColor;
}

class HorizontalModule extends StatelessWidget {
  ModuleItem moduleItem;
  bool hasBorder;

  HorizontalModule(
      {super.key, required this.moduleItem, this.hasBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: getMenuColor(context) ?? Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: hasBorder
                ? Border.all(width: 1, color: Colors.grey[400]!)
                : null),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MenuItemImage(
                imageUrl: moduleItem.moduleUrl ?? "",
              ),
              const SizedBox(
                width: 8,
              ),
              MenuItemTitle(title: moduleItem.moduleName)
            ],
          ),
        ));
  }

  Color? getMenuColor(context) =>
      Provider.of<PluginState>(context, listen: false).menuColor;
}

class ModuleUtil {
  static onItemClick(ModuleItem moduleItem, BuildContext context) {
    bool isDisabled = moduleItem.isDisabled ?? false;

    if (isDisabled) {
      CommonUtils.showToast("Coming soon");
      return;
    }
    switch (EnumFormatter.getModuleId(moduleItem.moduleId)) {
      case ModuleId.FINGERPRINT:
        {
          CommonUtils.navigateToRoute(
              context: context, widget: const BiometricLogin());
          break;
        }
      case ModuleId.TRANSACTIONSCENTER:
        {
          getTransactionList(context, moduleItem);
          break;
        }
      case ModuleId.PENDINGTRANSACTIONS:
        {
          break;
        }
      case ModuleId.VIEWBENEFICIARY:
        {
          CommonUtils.navigateToRoute(
              context: context,
              widget: ViewBeneficiary(moduleItem: moduleItem));
          break;
        }
      case ModuleId.STANDINGORDERVIEWDETAILS:
        {
          CommonUtils.navigateToRoute(
              context: context,
              widget: ViewStandingOrder(moduleItem: moduleItem));
          break;
        }
      case ModuleId.BOOKCAB:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Ride.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.MERCHANTPAYMENT:
        {
          NativeBinder.invokeMethod(LittleProduct
              .PayMerchants.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.TOPUPWALLET:
        {
          NativeBinder.invokeMethod(LittleProduct
              .LoadWallet.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.FOOD:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.PHARMACY:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.SUPERMARKET:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.GROCERIES:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.GAS:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.DRINKS:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      case ModuleId.CAKE:
        {
          NativeBinder.invokeMethod(LittleProduct
              .Deliveries.name); //Ride Deliveries LoadWallet PayMerchants
          break;
        }
      default:
        {
          CommonUtils.navigateToRoute(
              context: context,
              widget: DynamicWidget(
                moduleItem: moduleItem,
              ));
        }
    }
  }

  static getTransactionList(context, moduleItem) {
    CommonUtils.navigateToRoute(
        context: context, widget: TransactionList(moduleItem: moduleItem));
  }
}
