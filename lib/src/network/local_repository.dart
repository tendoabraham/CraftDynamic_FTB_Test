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
  Box<ModuleItem>? modulesBox;

  openBox() async {
    modulesBox = await Hive.openBox<ModuleItem>("modules");
  }

  insertModuleItem(ModuleItem moduleItem) async {
    await openBox();
    try {
      modulesBox?.put(moduleItem.moduleId, moduleItem);
    } catch (e) {
      AppLogger.appLogE(tag: "module insertion", message: e.toString());
    }
  }

  Future<ModuleItem?> getModuleById(String moduleID) async {
    await openBox();
    return modulesBox?.get(moduleID);
  }

  Future<List<ModuleItem>?> getModulesById(String moduleID) async {
    await openBox();
    return modulesBox?.values
        .where(
            (item) => item.parentModule == moduleID && item.isHidden == false)
        .toList();
  }

  Future<List<ModuleItem>?> searchModuleItem(String moduleName) async {
    await openBox();
    return modulesBox?.values
        .where(
            (item) => item.moduleName == moduleName && item.isHidden == false)
        .toList();
  }

  Future<List<ModuleItem>?> getTabModules() async {
    await openBox();
    var modules = modulesBox?.values
        .where((item) => item.isMainMenu == true && item.isHidden == false)
        .toList();
    return modules;
  }

  clearTable() async {
    await openBox();
    modulesBox?.clear();
  }
}

class FormsRepository {
  Box<FormItem>? formsBox;

  openBox() async {
    formsBox = await Hive.openBox<FormItem>("forms");
  }

  insertFormItem(FormItem formItem) async {
    await openBox();
    formsBox?.add(formItem);
  }

  Future<List<FormItem>?> getFormsByModuleId(String moduleID) async {
    await openBox();
    return formsBox?.values
        .where((item) => item.moduleId == moduleID && item.hidden == false)
        .toList();
  }

  Future<List<FormItem>?>? getFormsByModuleIdAndFormSequence(
      String moduleID, int formSequence) async {
    await openBox();
    return formsBox?.values
        .where((item) =>
            item.moduleId == moduleID &&
            item.formSequence == formSequence &&
            item.hidden == false)
        .toList();
  }

  Future<List<FormItem>?>? getFormsByModuleIdAndControlID(
      String moduleID, String controlID) async {
    await openBox();
    return formsBox?.values
        .where((item) =>
            item.moduleId == moduleID &&
            item.controlId == controlID &&
            item.hidden == false)
        .toList();
  }

  clearTable() async {
    await openBox();
    formsBox?.clear();
  }
}

class ActionControlRepository {
  var actionsBox;

  openBox() async {
    actionsBox = await HiveBox(ActionItem).getBox("actions");
  }

  insertActionControl(ActionItem actionItem) async {
    await openBox();
    actionsBox.add(actionItem);
  }

  Future<ActionItem>? getActionControlByModuleIdAndControlId(
      String moduleID, controlID) async {
    await openBox();
    return actionsBox.values.firstWhere(
        (item) => item.moduleID == moduleID && item.controlID == controlID);
  }

  clearTable() async {
    await openBox();
    actionsBox.clear();
  }
}

class UserCodeRepository {
  var userCodeBox;

  openBox() async {
    userCodeBox = await HiveBox(UserCode).getBox("usercodes");
  }

  insertUserCode(UserCode userCode) async {
    await openBox();
    userCodeBox.put(userCode.no ?? "", userCode);
  }

  Future<List<UserCode>> getUserCodesById(String? id) async {
    await openBox();
    return userCodeBox.values.where((item) => item.id == id).toList();
  }

  clearTable() async {
    await openBox();
    userCodeBox.clear();
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
  Box<BankAccount>? bankAccountBox;

  openBox() async {
    bankAccountBox = await Hive.openBox<BankAccount>("bankaccount");
  }

  insertBankAccount(BankAccount bankAccount) async {
    await openBox();
    try {
      AppLogger.appLogI(
          tag: "add bank accont", message: bankAccount.bankAccountId);
      bankAccountBox?.add(bankAccount);
    } catch (e) {
      AppLogger.appLogE(tag: "add bank account", message: e.toString());
    }
  }

  Future<List<BankAccount>?> getAllBankAccounts() async {
    await openBox();
    var accounts = bankAccountBox?.values.toList();
    AppLogger.appLogI(tag: "all accounts", message: accounts);
    return accounts;
  }

  clearTable() async {
    await openBox();
    bankAccountBox?.clear();
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
  var beneficiaryBox;

  openBox() async {
    beneficiaryBox = await HiveBox(Beneficiary).getBox("beneficiaries");
  }

  insertBeneficiary(Beneficiary beneficiary) async {
    await openBox();
    beneficiaryBox.put(beneficiary.rowId, beneficiary);
  }

  Future<List<Beneficiary>>? getAllBeneficiaries() async {
    await openBox();
    return beneficiaryBox.values.toList();
  }

  Future<List<Beneficiary>>? getBeneficiariesByMerchantID(
      String merchantID) async {
    await openBox();
    return beneficiaryBox.values
        .where((item) => item.merchantID == merchantID)
        .toList();
  }

  deleteBeneficiary(int rowId) async {
    await openBox();
    beneficiaryBox.delete(rowId);
  }

  clearTable() async {
    await openBox();
    beneficiaryBox.clear();
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
