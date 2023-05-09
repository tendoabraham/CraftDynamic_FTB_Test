import '../../craft_dynamic.dart';

final _sharedPref = CommonSharedPref();
final _bankAccountRepository = BankAccountRepository();
final _beneficiaryRepository = BeneficiaryRepository();
final _frequentAccessedModulesRepository = FrequentAccessedModuleRepository();
final _moduleToDisableRepository = ModuleToDisableRepository();
final _pendingTransactionsRepository = PendingTrxDisplayRepository();
final _moduleToHideRepository = ModuleToHideRepository();
final _userCodeRepository = UserCodeRepository();
final _onlineAccountProductRepository = OnlineAccountProductRepository();
final _bankBranchRepository = BankBranchRepository();
final _imageDataRepository = ImageDataRepository();
final _atmLocationRepository = AtmLocationRepository();
final _branchLocationRepository = BranchLocationRepository();
final _moduleRepository = ModuleRepository();
final _formRepository = FormsRepository();
final _actionControlRepository = ActionControlRepository();

class UIDataRepository {
  addUIDataToDB({required UIResponse? uiResponse}) {
    if (uiResponse?.formControl != null) {
      _formRepository.clearTable();
      uiResponse?.formControl?.forEach((item) {
        _formRepository.insertFormItem(FormItem.fromJson(item));
      });
    }
    if (uiResponse?.actionControl != null) {
      _actionControlRepository.clearTable();
      uiResponse?.actionControl?.forEach((item) {
        _actionControlRepository.insertActionControl(ActionItem.fromJson(item));
      });
    }
    if (uiResponse?.module != null) {
      _moduleRepository.clearTable();
      uiResponse?.module?.forEach((item) {
        _moduleRepository.insertModuleItem(ModuleItem.fromJson(item));
      });
    }
  }
}

class UserAccountRepository {
  addUserAccountData(ActivationResponse activationResponse) {
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.FirstName.name,
        value: activationResponse.firstName);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.LastName.name, value: activationResponse.lastName);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.IDNumber.name, value: activationResponse.idNumber);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.EmailID.name, value: activationResponse.emailID);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.ImageUrl.name, value: activationResponse.imageUrl);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.LastLoginDateTime.name,
        value: activationResponse.lastLoginDate);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.Phone.name, value: activationResponse.phone);
    activationResponse.accounts?.forEach((item) {
      _bankAccountRepository.insertBankAccount(BankAccount.fromJson(item));
    });
    activationResponse.frequentAccessedModules?.forEach((item) {
      _frequentAccessedModulesRepository
          .insertFrequentModule(FrequentAccessedModule.fromJson(item));
    });
    activationResponse.beneficiary?.forEach((item) {
      _beneficiaryRepository.insertBeneficiary(Beneficiary.fromJson(item));
    });
    activationResponse.modulesToHide?.forEach((item) {
      _moduleToHideRepository.insertModuleToHide(ModuleToHide.fromJson(item));
    });
    activationResponse.modulesToHide?.forEach((item) {
      _moduleToDisableRepository
          .insertModuleToDisable(ModuleToDisable.fromJson(item));
    });
    activationResponse.pendingTransactions?.forEach((item) {
      _pendingTransactionsRepository
          .insertPendingTransaction(PendingTrxDisplay.fromJson(item));
    });
  }
}

class StaticDataRepository {
  addStaticData(StaticResponse? staticResponse) async {
    await _sharedPref.addAppIdleTimeout(staticResponse?.appIdleTimeout);
    await ClearDB.clearAllStaticData();
    staticResponse?.usercode?.forEach((item) {
      _userCodeRepository.insertUserCode(UserCode.fromJson(item));
    });
    staticResponse?.onlineAccountProduct?.forEach((item) {
      _onlineAccountProductRepository
          .insertOnlineAccountProduct(OnlineAccountProduct.fromJson(item));
    });
    staticResponse?.bankBranch?.forEach((item) {
      _bankBranchRepository.insertBankBranch(BankBranch.fromJson(item));
    });
    staticResponse?.image?.forEach((item) {
      _imageDataRepository.insertImageData(ImageData.fromJson(item));
    });
    staticResponse?.atmLocation?.forEach((item) {
      _atmLocationRepository.insertAtmLocation(AtmLocation.fromJson(item));
    });
    staticResponse?.branchLocation?.forEach((item) {
      _branchLocationRepository
          .insertBranchLocation(BranchLocation.fromJson(item));
    });
  }
}

class ClearDB {
  static clearAllUserData() {
    _bankAccountRepository.clearTable();
    _frequentAccessedModulesRepository.clearTable();
    _beneficiaryRepository.clearTable();
    _moduleToDisableRepository.clearTable();
    _moduleToHideRepository.clearTable();
    _pendingTransactionsRepository.clearTable();
  }

  static clearAllStaticData() async {
    _userCodeRepository.clearTable();
    _onlineAccountProductRepository.clearTable();
    _bankBranchRepository.clearTable();
    _imageDataRepository.clearTable();
    _branchLocationRepository.clearTable();
    _atmLocationRepository.clearTable();
  }
}
