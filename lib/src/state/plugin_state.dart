import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../craft_dynamic.dart';

class PluginState extends ChangeNotifier {
  bool _loadingNetworkData = false;
  bool _obscureText = true;
  bool _deleteFormValues = true;
  bool _scanvalidationloading = false;
  String _currentTab = "";
  Widget? _logoutScreen;
  MenuType? _menuType;
  Color? _menuColor;
  final Map<String?, dynamic> _formInputValues = {};
  final Map<String?, dynamic> _encryptedFields = {};
  final Map<String?, dynamic> _screenDropDowns = {};
  final Map<String?, dynamic> _toAndFromAccounts = {};

  bool get loadingNetworkData => _loadingNetworkData;

  String get currentTab => _currentTab;

  bool get obscureText => _obscureText;

  bool get deleteFormInput => _deleteFormValues;

  bool get scanvalidationloading => _scanvalidationloading;

  Widget? get logoutScreen => _logoutScreen;

  MenuType? get menuType => _menuType;

  Color? get menuColor => _menuColor;

  Map<String?, dynamic> get formInputValues => _formInputValues;

  Map<String?, dynamic> get encryptedFields => _encryptedFields;

  Map<String?, dynamic> get screenDropDowns => _screenDropDowns;

  Map<String?, dynamic> get toAndFromAccounts => _toAndFromAccounts;

  void setRequestState(bool state, {String? currentTab}) {
    _loadingNetworkData = state;
    _currentTab = currentTab ?? "";
    notifyListeners();
  }

  changeVisibility(bool visibility) {
    _obscureText = visibility;
    notifyListeners();
  }

  changeBiometricStatus(bool biometricStatus) {
    notifyListeners();
  }

  setDeleteForm(bool status) {
    _deleteFormValues = status;
    notifyListeners();
  }

  setLogoutScreen(Widget widget) {
    _logoutScreen = widget;
  }

  setMenuType(MenuType menuType) {
    _menuType = menuType;
  }

  setMenuColor(Color color) {
    _menuColor = color;
  }

  setScanValidationLoading(bool state) {
    _scanvalidationloading = state;
    notifyListeners();
  }

  addFormInput(Map<String?, dynamic> formInput) {
    _formInputValues.addAll(formInput);
    notifyListeners();
  }

  addEncryptedFields(Map<String?, dynamic> encryptedField) {
    _encryptedFields.addAll(encryptedField);
    notifyListeners();
  }

  addScreenDropDown(Map<String?, dynamic> screenDropDown) {
    _screenDropDowns.addAll(screenDropDown);
    notifyListeners();
  }

  setToAndFroAccount(Map<String?, dynamic> input) {
    _toAndFromAccounts.addAll(input);
    notifyListeners();
  }

  clearDynamicInput() {
    _formInputValues.clear();
    _encryptedFields.clear();
    _screenDropDowns.clear();
    _toAndFromAccounts.clear();
    notifyListeners();
  }
}

class DynamicState extends ChangeNotifier {
  MenuScreenProperties? _menuScreenProperties;
  MenuProperties? _menuProperties;

  MenuScreenProperties? get menuScreenProperties => _menuScreenProperties;

  MenuProperties? get menuProperties => _menuProperties;

  setMenuScreen(MenuScreenProperties properties) {
    _menuScreenProperties = properties;
  }

  setMenuProperties(MenuProperties menuProperties) {
    _menuProperties = menuProperties;
  }
}

class DropDownState extends ChangeNotifier {}

var currentToken = "".obs;

var showLoadingScreen = false.obs;

var isBiometricEnabled = false.obs;

var isCallingService = false.obs;

var currentStepperIndex = 0.obs;

var isStepperForm = false.obs;

var deleteFormInput = true.obs;

var selectedRadio = "".obs;

var currentIv = "".obs;
var currentKey = "".obs;

var currentBankID = "".obs;

var connectionState = ConnectivityResult.none.obs;

RxList<Map<String, dynamic>> currentLinkedValue = <Map<String, dynamic>>[].obs;

var isDeletingStandingOrder = false.obs;

var isGettingToken = false.obs;
