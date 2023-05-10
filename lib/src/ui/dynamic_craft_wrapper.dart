part of craft_dynamic;

class DynamicCraftWrapper extends StatefulWidget {
  final Widget dashboard;
  final Widget appLoadingScreen;
  final Widget appTimeoutScreen;
  final Widget appInactivityScreen;
  final ThemeData appTheme;
  MenuScreenProperties? menuScreenProperties;
  MenuProperties? menuProperties;
  bool localizationIsEnabled;

  DynamicCraftWrapper(
      {super.key,
      required this.dashboard,
      required this.appLoadingScreen,
      required this.appTimeoutScreen,
      required this.appInactivityScreen,
      required this.appTheme,
      this.menuScreenProperties,
      this.menuProperties,
      this.localizationIsEnabled = false});

  @override
  State<DynamicCraftWrapper> createState() => _DynamicCraftWrapperState();
}

class _DynamicCraftWrapperState extends State<DynamicCraftWrapper> {
  final _connectivityService = ConnectivityService();
  final _initRepository = InitRepository();
  final _sessionRepository = SessionRepository();
  final _sharedPref = CommonSharedPref();

  var _appTimeout = 100000;

  @override
  void initState() {
    super.initState();
    showLoadingScreen.value = true;
    initializeApp();
  }

  initializeApp() async {
    await initializeHive();
    await _connectivityService.initialize();
    _sessionRepository.stopSession();
    await getAppLaunchCount();
    if (!kIsWeb) {
      await PermissionUtil.checkRequiredPermissions();
    }
    getCurrentLatLong();
    await getAppData();
  }

  initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ModuleItemAdapter());
    Hive.registerAdapter(FormItemAdapter());
    Hive.registerAdapter(ActionItemAdapter());
    Hive.registerAdapter(UserCodeAdapter());
    Hive.registerAdapter(BankBranchAdapter());
    Hive.registerAdapter(AtmLocationAdapter());
    Hive.registerAdapter(ImageDataAdapter());
    Hive.registerAdapter(BranchLocationAdapter());
    Hive.registerAdapter(FrequentAccessedModuleAdapter());
    Hive.registerAdapter(BankAccountAdapter());
    Hive.registerAdapter(BeneficiaryAdapter());
    Hive.registerAdapter(ModuleToHideAdapter());
    Hive.registerAdapter(ModuleToDisableAdapter());
    Hive.registerAdapter(PendingTrxDisplayAdapter());
    Hive.registerAdapter(OnlineAccountProductAdapter());
  }

  getAppLaunchCount() async {
    var launchCount = await _sharedPref.getLaunchCount();
    if (launchCount == 0) {
      _sharedPref.clearPrefs();
      _sharedPref.setLaunchCount(launchCount++);
      await _sharedPref.setLanguageID("ENG");
    }
    if (launchCount < 5) {
      _sharedPref.setLaunchCount(launchCount++);
    }
  }

  getAppData() async {
    await _initRepository.getAppToken();
    await _initRepository.getAppUIData();
    showLoadingScreen.value = false;
    var timeout = await _sharedPref.getAppIdleTimeout();
    setState(() {
      _appTimeout = timeout;
    });
    periodicActions(_appTimeout);
  }

  periodicActions(int timeout) {
    Timer.periodic(Duration(milliseconds: timeout), (timer) {
      _sharedPref.setTokenIsRefreshed(false);
      _initRepository.getAppToken();
      getCurrentLatLong();
    });
  }

  getCurrentLatLong() {
    LocationUtil.getLatLong().then((value) {
      _sharedPref.setLatLong(json.encode(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _sessionRepository.getSessionManager(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => PluginState()),
            ChangeNotifierProvider(create: (context) => DynamicState()),
          ],
          child: GetMaterialApp(
            localizationsDelegates: widget.localizationIsEnabled
                ? context.localizationDelegates
                : null,
            supportedLocales: widget.localizationIsEnabled
                ? context.supportedLocales
                : [const Locale('en')],
            locale: widget.localizationIsEnabled ? context.locale : null,
            debugShowCheckedModeBanner: false,
            theme: widget.appTheme,
            home: Obx(() {
              return showLoadingScreen.value
                  ? widget.appLoadingScreen
                  : widget.dashboard;
            }),
            navigatorKey: Get.key,
            builder: (context, child) {
              setPluginWidgets(widget.appTimeoutScreen, context,
                  widget.menuProperties, widget.menuScreenProperties);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          ),
        ),
        context: context,
        _appTimeout,
        widget.appInactivityScreen,
        widget.appTimeoutScreen);
  }

  setPluginWidgets(
      Widget logoutWidget,
      BuildContext context,
      MenuProperties? menuProperties,
      MenuScreenProperties? menuScreenProperties) {
    if (menuProperties != null) {
      Provider.of<DynamicState>(context, listen: false)
          .setMenuProperties(menuProperties);
    }

    if (menuScreenProperties != null) {
      Provider.of<DynamicState>(context, listen: false)
          .setMenuScreen(menuScreenProperties);
    }
    Provider.of<PluginState>(context, listen: false)
        .setLogoutScreen(logoutWidget);
  }
}
