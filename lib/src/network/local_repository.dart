import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:hive/hive.dart';

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
  var modulesBox = Hive.box<ModuleItem>('modules');

  insertModuleItem(ModuleItem moduleItem) {
    modulesBox.put(moduleItem.moduleId, moduleItem);
  }

  ModuleItem? getModuleById(String moduleID) {
    return modulesBox.get(moduleID);
  }

  List<ModuleItem> getModulesById(String moduleID) {
    return modulesBox.values
        .where(
            (item) => item.parentModule == moduleID && item.isHidden == false)
        .toList();
  }

  List<ModuleItem> searchModuleItem(String moduleName) {
    return modulesBox.values
        .where(
            (item) => item.moduleName == moduleName && item.isHidden == false)
        .toList();
  }

  Future<List<ModuleItem>?> getTabModules() async {
    return modulesBox.values
        .where((item) => item.isMainMenu == true && item.isHidden == false)
        .toList();
  }

  clearTable() {
    modulesBox.deleteFromDisk();
  }
}

class FormsRepository {
  var formsBox = Hive.box<FormItem>("forms");

  insertFormItem(FormItem formItem) {
    formsBox.put(formItem.no, formItem);
  }

  List<FormItem> getFormsByModuleId(String moduleID) {
    return formsBox.values
        .where((item) => item.moduleId == moduleID && item.hidden == false)
        .toList();
  }

  List<FormItem>? getFormsByModuleIdAndFormSequence(
      String moduleID, int formSequence) {
    return formsBox.values
        .where((item) =>
            item.moduleId == moduleID &&
            item.formSequence == formSequence &&
            item.hidden == false)
        .toList();
  }

  List<FormItem>? getFormsByModuleIdAndControlID(
      String moduleID, String controlID) {
    return formsBox.values
        .where((item) =>
            item.moduleId == moduleID &&
            item.controlId == controlID &&
            item.hidden == false)
        .toList();
  }

  clearTable() {
    formsBox.deleteFromDisk();
  }
}

class ActionControlRepository {
  var actionsBox = Hive.box<ActionItem>("actions");

  insertActionControl(ActionItem actionItem) {
    actionsBox.put(actionItem.no, actionItem);
  }

  ActionItem? getActionControlByModuleIdAndControlId(
      String moduleID, controlID) {
    return actionsBox.values.firstWhere(
        (item) => item.moduleID == moduleID && item.controlID == controlID);
  }

  void clearTable() async {
    actionsBox.deleteFromDisk();
  }
}

class UserCodeRepository {
  var userCodeBox = Hive.box<UserCode>("usercodes");
  void insertUserCode(UserCode userCode) {
    userCodeBox.put(userCode.no, userCode);
  }

  List<UserCode> getUserCodesById(String? id) {
    return userCodeBox.values.where((item) => item.id == id).toList();
  }

  void clearTable() async {
    userCodeBox.deleteFromDisk();
  }
}

class OnlineAccountProductRepository {
  var onlineAccountBox = Hive.box<OnlineAccountProduct>("onlineaccounts");

  void insertOnlineAccountProduct(
      OnlineAccountProduct onlineAccountProduct) async {
    onlineAccountBox.put(onlineAccountProduct.no, onlineAccountProduct);
  }

  List<OnlineAccountProduct> getAllOnlineAccountProducts() {
    return onlineAccountBox.values.toList();
  }

  void clearTable() async {
    onlineAccountBox.deleteFromDisk();
  }
}

class BankBranchRepository {
  var bankBranchBox = Hive.box<BankBranch>("bankbranches");

  void insertBankBranch(BankBranch bankBranch) async {
    bankBranchBox.put(bankBranch.no, bankBranch);
  }

  List<BankBranch> getAllBankBranches() {
    return bankBranchBox.values.toList();
  }

  void clearTable() async {
    bankBranchBox.deleteFromDisk();
  }
}

class ImageDataRepository {
  var imageDataBox = Hive.box<ImageData>("imagedata");

  void insertImageData(ImageData imageData) {
    imageDataBox.put(imageData.no, imageData);
  }

  List<ImageData> getAllImages(String imageType) {
    return imageDataBox.values.toList();
  }

  void clearTable() async {
    imageDataBox.deleteFromDisk();
  }
}

class BankAccountRepository {
  var bankAccountBox = Hive.box<BankAccount>("bankaccount");

  void insertBankAccount(BankAccount bankAccount) async {
    bankAccountBox.put(bankAccount.no, bankAccount);
  }

  List<BankAccount> getAllBankAccounts() {
    return bankAccountBox.values.toList();
  }

  void clearTable() async {
    bankAccountBox.deleteFromDisk();
  }
}

class FrequentAccessedModuleRepository {
  var frequentModulesBox = Hive.box<FrequentAccessedModule>("frequentmodules");
  void insertFrequentModule(FrequentAccessedModule frequentAccessedModule) {
    frequentModulesBox.put(frequentAccessedModule.no, frequentAccessedModule);
  }

  List<FrequentAccessedModule> getAllFrequentModules() {
    return frequentModulesBox.values.toList();
  }

  void clearTable() async {
    frequentModulesBox.deleteFromDisk();
  }
}

class BeneficiaryRepository {
  var beneficiaryBox = Hive.box<Beneficiary>("beneficiaries");

  void insertBeneficiary(Beneficiary beneficiary) {
    beneficiaryBox.put(beneficiary.rowId, beneficiary);
  }

  List<Beneficiary>? getAllBeneficiaries() {
    return beneficiaryBox.values.toList();
  }

  List<Beneficiary>? getBeneficiariesByMerchantID(String merchantID) {
    return beneficiaryBox.values
        .where((item) => item.merchantID == merchantID)
        .toList();
  }

  deleteBeneficiary(int rowId) {
    beneficiaryBox.delete(rowId);
  }

  Future<void> clearTable() async {
    beneficiaryBox.deleteFromDisk();
  }
}

class ModuleToHideRepository {
  var modulesToHideBox = Hive.box<ModuleToHide>("modulestohide");

  void insertModuleToHide(ModuleToHide moduleToHide) async {
    modulesToHideBox.put(moduleToHide.moduleId, moduleToHide);
  }

  List<ModuleToHide>? getAllModulesToHide() {
    return modulesToHideBox.values.toList();
  }

  void clearTable() async {
    modulesToHideBox.deleteFromDisk();
  }
}

class ModuleToDisableRepository {
  var modulesToDisableBox = Hive.box<ModuleToDisable>("modulestodisable");

  void insertModuleToDisable(ModuleToDisable moduleToDisable) async {
    modulesToDisableBox.put(moduleToDisable.moduleID, moduleToDisable);
  }

  List<ModuleToDisable>? getAllModulesToDisable() {
    return modulesToDisableBox.values.toList();
  }

  void clearTable() async {
    modulesToDisableBox.deleteFromDisk();
  }
}

class AtmLocationRepository {
  var atmsBox = Hive.box<AtmLocation>("atms");

  void insertAtmLocation(AtmLocation atmLocation) {
    atmsBox.put(atmLocation.no, atmLocation);
  }

  List<AtmLocation> getAllAtmLocations() {
    return atmsBox.values.toList();
  }

  void clearTable() async {
    atmsBox.deleteFromDisk();
  }
}

class BranchLocationRepository {
  var branchLocationRepo = Hive.box<BranchLocation>("branchlocations");

  void insertBranchLocation(BranchLocation branchLocation) async {
    branchLocationRepo.put(branchLocation.no, branchLocation);
  }

  List<BranchLocation> getAllBranchLocations() {
    return branchLocationRepo.values.toList();
  }

  void clearTable() async {
    branchLocationRepo.deleteFromDisk();
  }
}

class PendingTrxDisplayRepository {
  var pendingTransactionsBox =
      Hive.box<PendingTrxDisplay>("pendingtransactions");

  void insertPendingTransaction(PendingTrxDisplay pendingTrxDisplay) async {
    pendingTransactionsBox.put(pendingTrxDisplay.no, pendingTrxDisplay);
  }

  List<PendingTrxDisplay> getAllPendingTransactions() {
    return pendingTransactionsBox.values.toList();
  }

  void clearTable() async {
    pendingTransactionsBox.deleteFromDisk();
  }
}
