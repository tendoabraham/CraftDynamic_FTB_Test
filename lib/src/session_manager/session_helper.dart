part of craft_dynamic;

class SessionRepository {
  static final SessionRepository _singleton = SessionRepository._internal();
  final sessionStateStream = StreamController<SessionState>();
  final _sharedPref = CommonSharedPref();

  factory SessionRepository() {
    return _singleton;
  }

  void startSession() {
    sessionStateStream.add(SessionState.startListening);
  }

  void stopSession() {
    sessionStateStream.add(SessionState.stopListening);
  }

  MySessionConfig config({required appTimeout}) {
    return MySessionConfig(
        invalidateSessionForAppLostFocus:
            Duration(milliseconds: appTimeout == null ? 5000 : appTimeout!),
        invalidateSessionForUserInactiviity:
            const Duration(milliseconds: 1500));
  }

  void addSessionStateStream(MySessionConfig sessionConfig,
      {required BuildContext context,
      required Widget inactivityTimeoutRoute,
      required Widget focusTimeoutRoute}) {
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      sessionStateStream.add(SessionState.stopListening);

      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        AppLogger.appLogD(tag: "Session", message: "App inactivity...");
        try {
          _sharedPref.getAppIsActivated().then((value) {
            if (value == "true") {
              CommonUtils.getXRouteAndPopAll(widget: inactivityTimeoutRoute);
            }
          });
        } catch (e) {
          AppLogger.appLogD(tag: "Session:error", message: e.toString());
        }
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        AppLogger.appLogD(tag: "Session", message: "App lost focus...");
        try {
          _sharedPref.getAppIsActivated().then((value) {
            if (value == "true") {
              CommonUtils.getXRouteAndPopAll(widget: focusTimeoutRoute);
            }
          });
        } catch (e) {
          AppLogger.appLogI(tag: "Session:error", message: e.toString());
        }
      }
    });
  }

  Widget getSessionManager(Widget child, int appTimeout,
      Widget inactivityTimeoutRoute, Widget focusTimeoutRoute,
      {required context}) {
    final myConfig = config(appTimeout: appTimeout);
    addSessionStateStream(myConfig,
        context: context,
        inactivityTimeoutRoute: inactivityTimeoutRoute,
        focusTimeoutRoute: focusTimeoutRoute);
    return SessionTimeoutManager(
        sessionConfig: myConfig,
        sessionStateStream: sessionStateStream.stream,
        child: child);
  }

  SessionRepository._internal();
}
