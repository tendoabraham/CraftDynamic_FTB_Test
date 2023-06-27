part of craft_dynamic;

class ProfileRepository {
  final _bankRepository = BankAccountRepository();
  final _sharedPref = CommonSharedPref();
  final _services = APIService();

  Future<List<BankAccount>> getUserBankAccounts() async =>
      await _bankRepository.getAllBankAccounts() ?? [];

  getUserInfo(UserAccountData key) => _sharedPref.getUserAccountInfo(key);

  Future<DynamicResponse?> checkAccountBalance(String bankAccountID) async {
    return await _services.checkAccountBalance(
        bankAccountID: bankAccountID, merchantID: "BALANCE", moduleID: "HOME");
  }

  String getActualBalanceText(DynamicResponse dynamicResponse) {
    return dynamicResponse.resultsData
            ?.firstWhere((e) => e["ControlID"] == "BALTEXT")["ControlValue"] ??
        "Not available";
  }

  Future<DynamicResponse?> checkMiniStatement(String bankAccountID,
      {merchantID = "MINISTATEMENT"}) {
    return _services.checkMiniStatement(
        bankAccountID: bankAccountID,
        merchantID: merchantID,
        moduleID: merchantID);
  }
}
