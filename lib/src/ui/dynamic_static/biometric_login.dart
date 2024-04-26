// ignore_for_file: use_build_context_synchronously

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:local_auth/local_auth.dart';

final _sharedPref = CommonSharedPref();

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({super.key});

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {
  final String enableMessage = "Enter your pin to enable fingerprint login";
  final String disableMessage = "Enter your pin to disable fingerprint login";
  bool isBioEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBioIsEnabled();
  }

  _checkBioIsEnabled() async {
    String? bioEnabled = await _sharedPref.getBio();
    if (bioEnabled != null && bioEnabled == "true") {
      isBiometricEnabled.value = true;
    } else {
      isBiometricEnabled.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      //set border radius more than 50% of height and width to make circle
                    ),
                    color: const Color.fromARGB(255, 0, 80, 170),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Image(
                              image: AssetImage("assets/images/back_arrow.png"),
                              width: 25,
                            ),
                          ),
                          Expanded(
                              child: Text("Enable Fingerprint/Face Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Myriad Pro",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(width: 25),
                        ],
                      ),
                    )),
              ),
              Expanded(child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  height: double.maxFinite,
                  color: const Color.fromARGB(255, 219, 220, 221),
                  child:               Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "packages/craft_dynamic/assets/images/fingerprint.png",
                          width: 77,
                          height: 77,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          "Login with Fingerprint/Face",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          "Use fingerprint for faster and easy access to your account",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 44.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              enableDisableBioDialog(context: context);
                            },
                            child: Obx(() => Text(isBiometricEnabled.value
                                ? "Disable Fingerprint Login"
                                : "Enable Fingerprint Login")))
                      ],
                    ),
                  ))),
            ],
          ),
        ));
  }

  enableDisableBioDialog({context}) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (BuildContext context) => const ModalBottomSheet());
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final LocalAuthentication auth = LocalAuthentication();
  final _services = APIService();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isBioEnabled = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Enter PIN"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pin';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                _isLoading
                    ? Center(child: LoadUtil())
                    : Obx(() => WidgetFactory.buildButton(
                    context,
                    enableBiometric,
                    isBiometricEnabled.value
                        ? "Disable Biometric"
                        : "Enable Biometric"))
              ],
            ),
          ),
        ));
  }

  enableBiometric() async {
    if (await canBiometricAuthenticate()) {
      var enrolledFingerprints = await getEnrolledBiometrics();
      if (enrolledFingerprints.length > 0) {
        _handleBiometrics(CryptLib.encryptField(_pinController.text));
      } else {
        CommonUtils.showToast("No fingerprints enrolled on this device",
            lenth: Toast.LENGTH_LONG);
      }
    }
  }

  _handleBiometrics(String encryptedPin) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () async {
        await _services.login(encryptedPin).then((value) async => {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (value.status == StatusCode.success.statusCode) {
              _sharedPref.setBioPin(encryptedPin);
              isBiometricEnabled.value
                  ? _sharedPref.setBio(false)
                  : _sharedPref.setBio(true);
              isBiometricEnabled.value = !isBiometricEnabled.value;
              Navigator.pop(context);
              _pinController.clear();
              CommonUtils.showToast(isBiometricEnabled.value
                  ? "Biometrics login enabled successfully"
                  : "Biometrics login disabled successfully");
            } else {
              CommonUtils.showToast(value.message);
            }
          }),
        });
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  getEnrolledBiometrics() async {
    final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    return availableBiometrics;
  }

  canBiometricAuthenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }
}
