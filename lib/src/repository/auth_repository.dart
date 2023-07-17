part of craft_dynamic;

final _userAccountRepository = UserAccountRepository();
final _initRepository = InitRepository();

class AuthRepository {
  final _services = APIService();

  Future<bool> biometricLogin(TextEditingController pinController,
      {isButtonAction = false}) async {
    String bioEnabled = await _sharedPref.getBio();
    if (bioEnabled == "true") {
      if (await BioMetricUtil.biometricAuthenticate()) {
        String bioPin = await _sharedPref.getBioPin();
        pinController.text = CryptLib.decryptField(encrypted: bioPin);
        var res = await login(pinController.text);
        if (res.status == StatusCode.success.statusCode) {
          return true;
        } else {
          CommonUtils.showToast(res.message ?? "Login failed");
          return false;
        }
      }
    } else {
      if (isButtonAction) {
        CommonUtils.showToast("Biometrics not enabled");
      }
    }
    return false;
  }

  // Call this method to login
  Future<ActivationResponse> login(String pin) async {
    String? currentLanguage = await _sharedPref.getLanguageID();
    bool refreshUIData = false;

    ActivationResponse activationResponse =
        await _services.login(CryptLib.encryptField(pin));
    if (activationResponse.status == StatusCode.success.statusCode) {
      await _userAccountRepository.addUserAccountData(activationResponse);
      String? currentLanguageIDSetting = activationResponse.languageID;

      if (currentLanguage != null &&
          currentLanguageIDSetting != null &&
          currentLanguageIDSetting != "" &&
          currentLanguage != currentLanguageIDSetting) {
        await _sharedPref.setLanguageID(currentLanguageIDSetting);
        refreshUIData = true;
      }
      await _initRepository.getAppUIData(refreshData: refreshUIData);
    } else if (activationResponse.status == StatusCode.changePin.statusCode) {
      _moduleRepository.getModuleById(ModuleId.PIN.name).then((module) {
        CommonUtils.getxNavigate(
            widget: DynamicWidget(
          moduleItem: module,
        ));
      });
    } else if (activationResponse.status ==
        StatusCode.setsecurityquestions.statusCode) {
      _moduleRepository
          .getModuleById(ModuleId.SECRETQUESTIONS.name)
          .then((module) {
        CommonUtils.getxNavigate(
            widget: DynamicWidget(
          moduleItem: module,
        ));
      });
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
    if (activationResponse.status == StatusCode.success.statusCode) {
      var bankID = activationResponse.message;
      if (bankID != null && bankID.isNotEmpty) {
        await _sharedPref.setBankID(bankID);
      }
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

  Future<ActivationResponse> standardOTPVerification(
      {mobileNumber,
      key,
      merchantID,
      serviceName,
      RouteUrl route = RouteUrl.auth}) async {
    return await _services.standardOTPVerify(
        mobileNumber: mobileNumber,
        key: key,
        merchantID: merchantID,
        serviceName: serviceName,
        url: route);
  }
}
