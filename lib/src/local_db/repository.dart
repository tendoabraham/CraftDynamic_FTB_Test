// // ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

// part of database;

// final db = AppDatabase.getDatabaseInstance();

// class ModuleRepository {
//   void insertModuleItem(ModuleItem moduleItem) async {
//     await db.then((database) {
//       database.moduleItemDao.insertModuleItem(moduleItem);
//     });
//   }

//   Future<List<ModuleItem>> getModulesById(String id) async {
//     var modules;
//     await db.then((database) {
//       modules = database.moduleItemDao.getModulesById(id);
//     });
//     return modules;
//   }

//   Future<List<ModuleItem>?> getTabModules() async {
//     var modules;
//     await db.then((database) {
//       modules = database.moduleItemDao.getTabModules();
//     });
//     return modules;
//   }

//   Future<ModuleItem?> getModuleById(String id) async {
//     var module;
//     await db.then((database) {
//       module = database.moduleItemDao.getModuleById(id);
//     });
//     return module;
//   }

//   Future<List<ModuleItem>> searchModuleItem(String moduleName) async {
//     var modules;
//     await db.then((database) {
//       modules = database.moduleItemDao.searchModuleItem('%$moduleName%');
//     });
//     return modules;
//   }

//   void clearTable() async {
//     await db.then((database) {
//       database.moduleItemDao.clearTable();
//     });
//   }
// }

// class FormsRepository {
//   void insertFormItem(FormItem formItem) async {
//     await db.then((database) {
//       database.formItemDao.insertFormItem(formItem);
//     });
//   }

//   Future<List<FormItem>> getFormsByModuleId(String id) async {
//     var formItems;
//     await db.then((database) {
//       formItems = database.formItemDao.getFormsByModuleId(id);
//     });
//     return formItems;
//   }

//   Future<List<FormItem>> getFormsByModuleIdAndFormSequence(
//       String id, int formSequence) async {
//     var formItems;
//     await db.then((database) {
//       formItems = database.formItemDao
//           .getFormsByModuleIdAndFormSequence(id, formSequence);
//     });
//     return formItems;
//   }

//   Future<List<FormItem>> getFormsByModuleIdAndControlID(
//       String id, controlID) async {
//     var formItems;
//     await db.then((database) {
//       formItems =
//           database.formItemDao.getFormsByModuleIdAndControlID(id, controlID);
//     });
//     return formItems;
//   }

//   void clearTable() async {
//     await db.then((database) {
//       database.formItemDao.clearTable();
//     });
//   }
// }

// class ActionControlRepository {
//   void insertActionControl(ActionItem actionItem) async {
//     await db.then((database) {
//       database.actionControlDao.insertActionControl(actionItem);
//     });
//   }

//   Future<ActionItem?> getActionControlByModuleIdAndControlId(
//       String moduleId, controlId) async {
//     var actionItems;
//     await db.then((database) {
//       actionItems = database.actionControlDao
//           .getActionControlByModuleIdAndControlId(moduleId, controlId);
//     });
//     return actionItems;
//   }

//   void clearTable() async {
//     await db.then((database) {
//       database.actionControlDao.clearTable();
//     });
//   }
// }

// class UserCodeRepository {
//   void insertUserCode(UserCode userCode) async {
//     await db.then((database) {
//       database.userCodeDao.insertUserCode(userCode);
//     });
//   }

//   Future<List<UserCode>> getUserCodesById(String? id) async {
//     var userCodes;
//     await db.then((database) {
//       userCodes = database.userCodeDao.getUserCodesById(id);
//     });
//     return userCodes;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.userCodeDao.clearTable();
//     });
//   }
// }

// class OnlineAccountProductRepository {
//   void insertOnlineAccountProduct(
//       OnlineAccountProduct onlineAccountProduct) async {
//     db.then((database) {
//       database.onlineAccountProductDao
//           .insertOnlineAccountProduct(onlineAccountProduct);
//     });
//   }

//   Future<List<OnlineAccountProduct>> getAllOnlineAccountProducts() async {
//     var onlineAccountProducts;
//     await db.then((database) {
//       onlineAccountProducts =
//           database.onlineAccountProductDao.getAllOnlineAccountProducts();
//     });
//     return onlineAccountProducts;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.onlineAccountProductDao.clearTable();
//     });
//   }
// }

// class BankBranchRepository {
//   void insertBankBranch(BankBranch bankBranch) async {
//     db.then((database) {
//       database.bankBranchDao.insertBankBranch(bankBranch);
//     });
//   }

//   Future<List<BankBranch>> getAllBankBranches() async {
//     return db.then((database) {
//       database.bankBranchDao.getAllBankBranches();
//     });
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.bankBranchDao.clearTable();
//     });
//   }
// }

// class ImageDataRepository {
//   void insertImageData(ImageData imageData) async {
//     db.then((database) {
//       database.imageDataDao.insertImage(imageData);
//     });
//   }

//   Future<List<ImageData>> getAllImages(String imageType) async {
//     var Images;

//     await db.then((database) {
//       Images = database.imageDataDao.getAllImages(imageType);
//     });
//     return Images;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.imageDataDao.clearTable();
//     });
//   }
// }

// class BankAccountRepository {
//   void insertBankAccount(BankAccount bankAccount) async {
//     db.then((database) {
//       database.bankAccountDao.insertBankAccount(bankAccount);
//     });
//   }

//   Future<List<BankAccount>> getAllBankAccounts() async {
//     var bankAccounts;

//     await db.then((database) {
//       bankAccounts = database.bankAccountDao.getAllBankAccounts();
//     });
//     return bankAccounts;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.bankAccountDao.clearTable();
//     });
//   }
// }

// class FrequentAccessedModuleRepository {
//   void insertFrequentModule(
//       FrequentAccessedModule frequentAccessedModule) async {
//     db.then((database) {
//       database.frequentAccessedModuleDao
//           .insertFrequentModule(frequentAccessedModule);
//     });
//   }

//   Future<List<FrequentAccessedModule>> getAllFrequentModules() async {
//     var frequentAccessedModules;
//     await db.then((database) {
//       frequentAccessedModules =
//           database.frequentAccessedModuleDao.getAllFrequentModules();
//     });
//     return frequentAccessedModules;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.frequentAccessedModuleDao.clearTable();
//     });
//   }
// }

// class BeneficiaryRepository {
//   void insertBeneficiary(Beneficiary beneficiary) async {
//     db.then((database) {
//       database.beneficiaryDao.insertBeneficiary(beneficiary);
//     });
//   }

//   Future<List<Beneficiary>?> getAllBeneficiaries() async {
//     var beneficiaries;

//     await db.then((database) {
//       beneficiaries = database.beneficiaryDao.getAllBeneficiaries();
//     });
//     return beneficiaries;
//   }

//   Future<List<Beneficiary>?> getBeneficiariesByMerchantID(
//       String merchantID) async {
//     var beneficiaries;

//     await db.then((database) {
//       beneficiaries =
//           database.beneficiaryDao.getBeneficiariesByMerchantID(merchantID);
//     });
//     return beneficiaries;
//   }

//   Future<void> deleteBeneficiary(int rowId) async {
//     await db.then((database) {
//       database.beneficiaryDao.deleteBeneficiary(rowId);
//     });
//   }

//   Future<void> clearTable() async {
//     await db.then((database) {
//       database.beneficiaryDao.clearTable();
//     });
//   }
// }

// class ModuleToHideRepository {
//   void insertModuleToHide(ModuleToHide moduleToHide) async {
//     db.then((database) {
//       database.moduleToHideDao.insertModuleToHide(moduleToHide);
//     });
//   }

//   Future<List<ModuleToHide>>? getAllModulesToHide() async {
//     var modulesToHide;

//     await db.then((database) {
//       modulesToHide = database.moduleToHideDao.getAllModulesToHide();
//     });
//     return modulesToHide;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.moduleToHideDao.clearTable();
//     });
//   }
// }

// class ModuleToDisableRepository {
//   void insertModuleToDisable(ModuleToDisable moduleToDisable) async {
//     db.then((database) {
//       database.moduleToDisableDao.insertModuleToDisable(moduleToDisable);
//     });
//   }

//   Future<Future<List<ModuleToDisable>>?> getAllModulesToDisable() async {
//     Future<List<ModuleToDisable>>? modulesToDisable;

//     await db.then((database) {
//       modulesToDisable = database.moduleToDisableDao.getAllModulesToDisable();
//     });
//     return modulesToDisable;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.moduleToDisableDao.clearTable();
//     });
//   }
// }

// class AtmLocationRepository {
//   void insertAtmLocation(AtmLocation atmLocation) async {
//     db.then((database) {
//       database.atmLocationDao.insertAtmLocation(atmLocation);
//     });
//   }

//   Future<List<AtmLocation>> getAllAtmLocations() async {
//     var atmLocations;
//     await db.then((database) {
//       atmLocations = database.atmLocationDao.getAllAtmLocations();
//     });
//     return atmLocations;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.atmLocationDao.clearTable();
//     });
//   }
// }

// class BranchLocationRepository {
//   void insertBranchLocation(BranchLocation branchLocation) async {
//     db.then((database) {
//       database.branchLocationDao.insertBranchLocation(branchLocation);
//     });
//   }

//   Future<List<BranchLocation>> getAllBranchLocations() async {
//     var branchLocations;
//     await db.then((database) {
//       branchLocations = database.branchLocationDao.getAllBranchLocations();
//     });
//     return branchLocations;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.branchLocationDao.clearTable();
//     });
//   }
// }

// class PendingTrxDisplayRepository {
//   void insertPendingTransaction(PendingTrxDisplay pendingTrxDisplay) async {
//     db.then((database) {
//       database.pendingTrxDisplayDao.insertPendingTransaction(pendingTrxDisplay);
//     });
//   }

//   Future<List<PendingTrxDisplay>> getAllPendingTransactions() async {
//     var pendingTransactions;
//     await db.then((database) {
//       pendingTransactions =
//           database.pendingTrxDisplayDao.getAllPendingTransactions();
//     });
//     return pendingTransactions;
//   }

//   void clearTable() async {
//     db.then((database) {
//       database.pendingTrxDisplayDao.clearTable();
//     });
//   }
// }
