// ignore_for_file: prefer_typing_uninitialized_variables

part of craft_dynamic;

class LocalRepository {
  static Future<void> openBoxes() async {
    await Hive.openBox<ModuleItem>('modules');
    await Hive.openBox<FormItem>('forms');
    await Hive.openBox<ActionItem>('actions');
    await Hive.openBox<UserCode>('usercodes');
    await Hive.openBox<OnlineAccountProduct>('onlineaccounts');
    await Hive.openBox<BankBranch>('bankbranches');
    await Hive.openBox<ImageData>('imagedata');
    await Hive.openBox<BankAccount>('bankaccount');
    await Hive.openBox<FrequentAccessedModule>('frequentmodules');
    await Hive.openBox<Beneficiary>('beneficiaries');
    await Hive.openBox<ModuleToHide>('modulestohide');
    await Hive.openBox<ModuleToDisable>('modulestodisable');
    await Hive.openBox<AtmLocation>('atms');
    await Hive.openBox<BranchLocation>('branchlocations');
    await Hive.openBox<PendingTrxDisplay>('pendingtransactions');
  }
}

class ModuleRepository {
  Future<Box<ModuleItem>> openBox() async {
    if (Hive.isBoxOpen("modules")) {
      return Hive.box<ModuleItem>("modules");
    } else {
      return await Hive.openBox<ModuleItem>("modules");
    }
  }

  insertModuleItems(List<ModuleItem> moduleItems) async {
    var box = await openBox();
    await box.clear();
    try {
      for (var module in moduleItems) {
        box.put(module.moduleId, module);
      }
    } catch (e) {
      AppLogger.appLogE(tag: "module insertion", message: e.toString());
    }
  }

  Future<ModuleItem?> getModuleById(String moduleID) async {
    var box = await openBox();
    return box.get(moduleID);
  }

  Future<List<ModuleItem>?> getModulesById(String moduleID) async {
    var box = await openBox();
    var modules = box.values
        .where(
            (item) => item.parentModule == moduleID && item.isHidden == false)
        .toList();
    modules
        .sort((a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0));
    return modules;
  }

  Future<List<ModuleItem>?> searchModuleItem(String moduleName) async {
    var box = await openBox();
    return box.values
        .where(
            (item) => item.moduleName == moduleName && item.isHidden == false)
        .toList();
  }

  Future<List<ModuleItem>?> getTabModules() async {
    var box = await openBox();
    var modules = box.values
        .where((item) => item.isMainMenu == true && item.isHidden == false)
        .toList();
    return modules;
  }
}

class FormsRepository {
  Future<Box<FormItem>> openBox() async {
    if (Hive.isBoxOpen("forms")) {
      return Hive.box<FormItem>("forms");
    } else {
      return await Hive.openBox<FormItem>("forms");
    }
  }

  insertFormItems(List<FormItem> formItems) async {
    var box = await openBox();
    await box.clear();
    try {
      for (var formItem in formItems) {
        box.add(formItem);
      }
    } catch (e) {
      AppLogger.appLogE(tag: "insert form item", message: e.toString());
    }
  }

  Future<List<FormItem>?> getFormsByModuleId(String moduleID) async {
    var box = await openBox();
    var forms = box.values
        .where((item) => item.moduleId == moduleID && item.hidden == false)
        .toList();
    forms.sort((a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0));
    return forms;
  }

  Future<List<FormItem>?>? getFormsByModuleIdAndFormSequence(
      String moduleID, int formSequence) async {
    var box = await openBox();
    return box.values
        .where((item) =>
            item.moduleId == moduleID &&
            item.formSequence == formSequence &&
            item.hidden == false)
        .toList();
  }

  Future<List<FormItem>?>? getFormsByModuleIdAndControlID(
      String moduleID, String controlID) async {
    var box = await openBox();
    return box.values
        .where((item) =>
            item.moduleId == moduleID &&
            item.controlId == controlID &&
            item.hidden == false)
        .toList();
  }
}

class ActionControlRepository {
  Future<Box<ActionItem>> openBox() async {
    if (Hive.isBoxOpen("actions")) {
      return Hive.box<ActionItem>("actions");
    } else {
      return await Hive.openBox<ActionItem>("actions");
    }
  }

  insertActionControls(List<ActionItem> actionItems) async {
    var box = await openBox();
    await box.clear();
    for (var actionItem in actionItems) {
      box.add(actionItem);
    }
  }

  Future<ActionItem?> getActionControlByModuleIdAndControlId(
      String moduleID, controlID) async {
    var box = await openBox();
    return box.values.firstWhereOrNull(
        (item) => item.moduleID == moduleID && item.controlID == controlID);
  }
}

class UserCodeRepository {
  Future<Box<UserCode>> openBox() async {
    if (Hive.isBoxOpen("usercodes")) {
      return Hive.box<UserCode>("usercodes");
    } else {
      return await Hive.openBox<UserCode>("usercodes");
    }
  }

  insertUserCodes(List<UserCode> userCodes) async {
    var box = await openBox();
    await box.clear();
    for (var usercode in userCodes) {
      box.add(usercode);
    }
  }

  Future<List<UserCode>> getUserCodesById(String? id) async {
    var box = await openBox();
    return box.values.where((item) => item.id == id).toList();
  }
}

class OnlineAccountProductRepository {
  var onlineAccountBox;

  openBox() async {
    onlineAccountBox =
        await HiveBox(OnlineAccountProduct).getBox("onlineaccounts");
  }

  insertOnlineAccountProduct(OnlineAccountProduct onlineAccountProduct) async {
    await openBox();
    onlineAccountBox.put(onlineAccountProduct.no, onlineAccountProduct);
  }

  Future<List<OnlineAccountProduct>> getAllOnlineAccountProducts() async {
    await openBox();
    return onlineAccountBox.values.toList();
  }

  clearTable() async {
    await openBox();
    onlineAccountBox.clear();
  }
}

class BankBranchRepository {
  insertBankBranch(BankBranch bankBranch) async {
    var bankBranchBox = await HiveBox(BankBranch).getBox("bankbranches");
    bankBranchBox?.put(bankBranch.no ?? "", bankBranch);
  }

  Future<List<BankBranch>> getAllBankBranches() async {
    Box<BankBranch> bankBranchBox =
        await HiveBox(BankBranch).getBox("bankbranches") as Box<BankBranch>;
    return bankBranchBox.values.toList();
  }

  clearTable() async {
    var bankBranchBox = await HiveBox(BankBranch).getBox("bankbranches");
    bankBranchBox?.clear();
  }
}

class ImageDataRepository {
  var imageDataBox;

  openBox() async {
    imageDataBox = await HiveBox(ImageData).getBox("imagedata");
  }

  insertImageData(ImageData imageData) async {
    await openBox();
    imageDataBox.put(imageData.no ?? "", imageData);
  }

  Future<List<ImageData>> getAllImages(String imageType) async {
    await openBox();
    return imageDataBox.values.toList();
  }

  clearTable() async {
    await openBox();
    imageDataBox.clear();
  }
}

class BankAccountRepository {
  Future<Box<BankAccount>> openBox() async {
    if (Hive.isBoxOpen("bankaccount")) {
      return Hive.box<BankAccount>("bankaccount");
    } else {
      return await Hive.openBox<BankAccount>("bankaccount");
    }
  }

  insertBankAccounts(List<BankAccount> bankAccounts) async {
    try {
      var box = await openBox();
      await box.clear();
      box.addAll(bankAccounts);
    } catch (e) {
      AppLogger.appLogE(tag: "add bank account", message: e.toString());
    }
  }

  Future<List<BankAccount>?> getAllBankAccounts() async {
    var box = await openBox();
    var accounts = box.values.toList();
    AppLogger.appLogI(tag: "all accounts", message: accounts);
    return accounts;
  }
}

class FrequentAccessedModuleRepository {
  var frequentModulesBox;

  openBox() async {
    frequentModulesBox =
        await HiveBox(FrequentAccessedModule).getBox("frequentmodules");
  }

  insertFrequentModule(FrequentAccessedModule frequentAccessedModule) async {
    await openBox();
    frequentModulesBox.put(frequentAccessedModule.no, frequentAccessedModule);
  }

  Future<List<FrequentAccessedModule>> getAllFrequentModules() async {
    await openBox();
    return frequentModulesBox.values.toList();
  }

  clearTable() async {
    await openBox();
    frequentModulesBox.clear();
  }
}

class BeneficiaryRepository {
  Future<Box<Beneficiary>> openBox() async {
    if (Hive.isBoxOpen("beneficiaries")) {
      return Hive.box<Beneficiary>("beneficiaries");
    } else {
      return await Hive.openBox<Beneficiary>("beneficiaries");
    }
  }

  insertBeneficiaries(List<Beneficiary> beneficiaries) async {
    var box = await openBox();
    await box.clear();
    for (var beneficiary in beneficiaries) {
      box.put(beneficiary.rowId, beneficiary);
    }
  }

  Future<List<Beneficiary>>? getAllBeneficiaries() async {
    var box = await openBox();
    return box.values.toList();
  }

  Future<List<Beneficiary>>? getBeneficiariesByMerchantID(
      String merchantID) async {
    var box = await openBox();
    return box.values.where((item) => item.merchantID == merchantID).toList();
  }

  deleteBeneficiary(int rowId) async {
    var box = await openBox();
    box.delete(rowId);
  }
}

class ModuleToHideRepository {
  Box<ModuleToHide>? modulesToHideBox;

  openBox() async {
    modulesToHideBox = await Hive.openBox<ModuleToHide>("modulestohide");
  }

  insertModuleToHide(ModuleToHide moduleToHide) async {
    await openBox();
    modulesToHideBox?.put(moduleToHide.moduleId, moduleToHide);
  }

  Future<List<ModuleToHide>?>? getAllModulesToHide() async {
    await openBox();
    return modulesToHideBox?.values.toList();
  }

  clearTable() async {
    await openBox();
    modulesToHideBox?.clear();
  }
}

class ModuleToDisableRepository {
  var modulesToDisableBox;

  openBox() async {
    modulesToDisableBox =
        await HiveBox(ModuleToDisable).getBox("modulestodisable");
  }

  insertModuleToDisable(ModuleToDisable moduleToDisable) async {
    await openBox();
    modulesToDisableBox.put(moduleToDisable.moduleID, moduleToDisable);
  }

  Future<List<ModuleToDisable>>? getAllModulesToDisable() async {
    await openBox();
    return modulesToDisableBox.values.toList();
  }

  clearTable() async {
    await openBox();
    modulesToDisableBox.clear();
  }
}

class AtmLocationRepository {
  var atmsBox;

  openBox() async {
    atmsBox = await HiveBox(AtmLocation).getBox("atmlocations");
  }

  insertAtmLocation(AtmLocation atmLocation) async {
    await openBox();
    atmsBox.put(atmLocation.no, atmLocation);
  }

  Future<List<AtmLocation>> getAllAtmLocations() async {
    await openBox();
    return atmsBox.values.toList();
  }

  clearTable() async {
    await openBox();
    atmsBox.clear();
  }
}

class BranchLocationRepository {
  var branchLocationRepo;

  openBox() async {
    branchLocationRepo =
        await HiveBox(BranchLocation).getBox("branchlocations");
  }

  insertBranchLocation(BranchLocation branchLocation) async {
    await openBox();
    branchLocationRepo.put(branchLocation.no, branchLocation);
  }

  Future<List<BranchLocation>> getAllBranchLocations() async {
    await openBox();
    return branchLocationRepo.values.toList();
  }

  clearTable() async {
    await openBox();
    branchLocationRepo.clear();
  }
}

class PendingTrxDisplayRepository {
  var pendingTransactionsBox;

  openBox() async {
    pendingTransactionsBox =
        await HiveBox(PendingTrxDisplay).getBox("pendingtransactions");
  }

  insertPendingTransaction(PendingTrxDisplay pendingTrxDisplay) async {
    await openBox();
    pendingTransactionsBox.put(pendingTrxDisplay.no, pendingTrxDisplay);
  }

  Future<List<PendingTrxDisplay>> getAllPendingTransactions() async {
    await openBox();
    return pendingTransactionsBox.values.toList();
  }

  clearTable() async {
    await openBox();
    pendingTransactionsBox.clear();
  }
}
