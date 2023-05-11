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
  addUIDataToDB({required UIResponse? uiResponse}) async {
    if (uiResponse?.formControl != null) {
      List<FormItem> forms = [];
      uiResponse?.formControl?.forEach((formItem) {
        forms.add(FormItem.fromJson(formItem));
      });
      _formRepository.insertFormItems(forms);
    }
    if (uiResponse?.actionControl != null) {
      List<ActionItem> actions = [];

      uiResponse?.actionControl?.forEach((actionItem) {
        actions.add(ActionItem.fromJson(actionItem));
      });
      _actionControlRepository.insertActionControls(actions);
    }
    if (uiResponse?.module != null) {
      List<ModuleItem> modules = [];
      uiResponse?.module?.forEach((item) {
        try {
          modules.add(ModuleItem.fromJson(item));
        } catch (e) {
          AppLogger.appLogE(tag: "module insertion", message: e.toString());
        }
      });
      _moduleRepository.insertModuleItems(modules);
    }
  }
}

class UserAccountRepository {
  addUserAccountData(ActivationResponse activationResponse) {
    List<BankAccount> userAccounts = [];
    List<Beneficiary> beneficiaries = [];

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
      userAccounts.add(BankAccount.fromJson(item));
    });
    _bankAccountRepository.insertBankAccounts(userAccounts);

    activationResponse.frequentAccessedModules?.forEach((item) {
      _frequentAccessedModulesRepository
          .insertFrequentModule(FrequentAccessedModule.fromJson(item));
    });

    activationResponse.beneficiary?.forEach((item) {
      beneficiaries.add(Beneficiary.fromJson(item));
    });
    _beneficiaryRepository.insertBeneficiaries(beneficiaries);

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
    List<UserCode> userCodes = [];

    staticResponse?.usercode?.forEach((item) {
      userCodes.add(UserCode.fromJson(item));
    });
    _userCodeRepository.insertUserCodes(userCodes);

    staticResponse?.onlineAccountProduct?.forEach((item) {
      _onlineAccountProductRepository
          .insertOnlineAccountProduct(OnlineAccountProduct.fromJson(item));
    });
    staticResponse?.bankBranch?.forEach((item) {
      _bankBranchRepository
          .insertBankBranch(BankBranch.fromJson(item)); //TODO UNCOMMENT THIS
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
  static clearAllUserData() async {
    await _frequentAccessedModulesRepository.clearTable();
    await _moduleToDisableRepository.clearTable();
    await _moduleToHideRepository.clearTable();
    await _pendingTransactionsRepository.clearTable();
  }

  static clearAllStaticData() async {
    await _onlineAccountProductRepository.clearTable();
    await _bankBranchRepository.clearTable();
    await _imageDataRepository.clearTable();
    await _branchLocationRepository.clearTable();
    await _atmLocationRepository.clearTable();
  }
}
