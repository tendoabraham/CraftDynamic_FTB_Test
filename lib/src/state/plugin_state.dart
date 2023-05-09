import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../craft_dynamic.dart';

class PluginState extends ChangeNotifier {
  bool _loadingNetworkData = false;
  bool _obscureText = true;
  bool _deleteFormValues = true;
  String _currentTab = "";
  Widget? _logoutScreen;
  MenuType? _menuType;
  Widget? _menuItem;
  Color? _menuColor;
  final List<Map<String?, dynamic>> _formInputValues = [];
  final List<Map<String?, dynamic>> _encryptedFields = [];

  bool get loadingNetworkData => _loadingNetworkData;

  String get currentTab => _currentTab;

  bool get obscureText => _obscureText;

  bool get deleteFormInput => _deleteFormValues;

  Widget? get logoutScreen => _logoutScreen;

  Widget? get menuItem => _menuItem;

  MenuType? get menuType => _menuType;

  Color? get menuColor => _menuColor;

  List<Map<String?, dynamic>> get formInputValues => _formInputValues;

  List<Map<String?, dynamic>> get encryptedFields => _encryptedFields;

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

  setMenuItem(Widget widget) {
    _menuItem = widget;
  }

  setMenuType(MenuType menuType) {
    _menuType = menuType;
  }

  setMenuColor(Color color) {
    _menuColor = color;
  }

  addFormInput(Map<String?, dynamic> formInput) {
    _formInputValues.add(formInput);
    notifyListeners();
  }

  addEncryptedFields(Map<String?, dynamic> encryptedField) {
    _encryptedFields.add(encryptedField);
    notifyListeners();
  }

  clearDynamicInput() {
    _formInputValues.clear();
    _encryptedFields.clear();
    notifyListeners();
  }
}

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
