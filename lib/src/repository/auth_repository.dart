part of craft_dynamic;

final _userAccountRepository = UserAccountRepository();
final _initRepository = InitRepository();

class AuthRepository {
  final _services = APIService();

  Future<bool> biometricLogin(TextEditingController controller) async {
    String bioEnabled = await _sharedPref.getBio();
    if (bioEnabled == "true") {
      if (await BioMetricUtil.biometricAuthenticate()) {
        String bioPin = await _sharedPref.getBioPin();
        controller.text = CryptLib.decryptField(encrypted: bioPin);
        var res = await login(controller.text);
        if (res.status == StatusCode.success.statusCode) {
          return true;
        } else {
          CommonUtils.showToast(res.message ?? "failed");
          return false;
        }
      }
    } else {
      CommonUtils.showToast("Fingerprint not enabled");
    }
    return false;
  }

  // Call this method to login
  Future<ActivationResponse> login(String pin) async {
    String? currentLanguage = await _sharedPref.getLanguageID();
    debugPrint("Current Language ID::::$currentLanguage");
    bool refreshUIData = false;

    ActivationResponse activationResponse =
        await _services.login(CryptLib.encryptField(pin));
    if (activationResponse.status == StatusCode.success.statusCode) {
      await ClearDB.clearAllUserData().then((data) async {
        AppLogger.appLogI(tag: "login", message: "adding accounts data");
        await _userAccountRepository.addUserAccountData(activationResponse);
      });
      String? currentLanguageIDSetting = activationResponse.languageID;

      debugPrint("Current language setting::::$currentLanguageIDSetting");
      if (currentLanguage != null &&
          currentLanguageIDSetting != null &&
          currentLanguageIDSetting != "" &&
          currentLanguage != currentLanguageIDSetting) {
        debugPrint("Refreshing UI controls after language change>>>>");
        await _sharedPref.setLanguageID(currentLanguageIDSetting);
        refreshUIData = true;
      }
      await _initRepository.getAppUIData(refreshData: refreshUIData);
    } else if (activationResponse.status == StatusCode.changePin.statusCode) {
      CommonUtils.getxNavigate(
          widget: DynamicWidget(
        moduleItem: await _moduleRepository.getModuleById(ModuleId.PIN.name),
      ));
    }
    return activationResponse;
  }

  // Call this method to activate app
  Future<ActivationResponse> activate(
      {required mobileNumber, required pin}) async {
    ActivationResponse activationResponse = await _services.activateMobile(
      mobileNumber: mobileNumber,
      encryptedPin: CryptLib.encryptField(pin),
    );
    var bankID = activationResponse.message;
    if (bankID != null && bankID.isNotEmpty) {
      await _sharedPref.setBankID(bankID);
    }
    return activationResponse;
  }

  // Call this method to verify otp
  Future<ActivationResponse> verifyOTP(
      {required mobileNumber, required otp}) async {
    ActivationResponse activationResponse =
        await _services.verifyOTP(mobileNumber: mobileNumber, key: otp);
    if (activationResponse.customerID != null &&
        activationResponse.customerID != "") {
      _sharedPref.addActivationData(
          mobileNumber, activationResponse.customerID!);

      await _initRepository.getAppUIData();
    }
    return activationResponse;
  }
}
