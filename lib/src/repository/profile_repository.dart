part of craft_dynamic;

class ProfileRepository {
  final _bankRepository = BankAccountRepository();
  final _sharedPref = CommonSharedPref();
  final _services = APIService();

  List<BankAccount> getUserBankAccounts() =>
      _bankRepository.getAllBankAccounts();

  getUserInfo(UserAccountData key) => _sharedPref.getUserAccountInfo(key);

  Future<String?> checkAccountBalance(String bankAccountID) async {
    String balance = "";
    await _services
        .checkAccountBalance(
            bankAccountID: bankAccountID,
            merchantID: "BALANCE",
            moduleID: "HOME")
        .then((value) {
      if (value?.status == StatusCode.success.statusCode) {
        balance = value?.resultsData?.firstWhere(
                (e) => e["ControlID"] == "BALTEXT")["ControlValue"] ??
            "Not available";
      } else {
        balance = "Error!";
        CommonUtils.showToast(value?.message ?? "Failed to get balance");
      }
    });
    return balance;
  }

  Future<DynamicResponse?> checkMiniStatement(String bankAccountID) {
    return _services.checkMiniStatement(
        bankAccountID: bankAccountID,
        merchantID: "STATEMENT",
        moduleID: "STATEMENT");
  }
}
