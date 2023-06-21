// ignore_for_file: must_be_immutable

part of craft_dynamic;

class TransactionReceipt extends StatefulWidget {
  final PostDynamic postDynamic;
  String? moduleName;

  TransactionReceipt({required this.postDynamic, this.moduleName, super.key});

  @override
  State<StatefulWidget> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt>
    with SingleTickerProviderStateMixin {
  late var _controller;

  @override
  void initState() {
    super.initState();
    Vibration.vibrate();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) {
            if (!_controller.isCompleted) {
              _controller.forward(from: 0.0);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var postDynamic = widget.postDynamic;

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
          body: Center(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ClipPath(
                          clipper: PointsClipper(),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0))),
                              padding: const EdgeInsets.only(
                                  bottom: 12, left: 12, right: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Lottie.asset(
                                        "packages/craft_dynamic/assets/lottie/success.json",
                                        height: 122,
                                        width: 122,
                                        controller: _controller,
                                        onLoaded: (comp) {
                                      _controller
                                        ..duration = comp.duration
                                        ..forward();
                                    }),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                          color: Colors.grey[300],
                                        )),
                                        const Text(
                                          "Success",
                                        ).tr(),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 44,
                                    ),
                                    Text(
                                      widget.moduleName ?? "",
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            postDynamic.receiptDetails?.length,
                                        itemBuilder: (context, index) {
                                          String title = MapItem.fromJson(
                                                  postDynamic
                                                      .receiptDetails?[index])
                                              .title;
                                          String? value = MapItem.fromJson(
                                                      postDynamic
                                                              .receiptDetails?[
                                                          index])
                                                  .value ??
                                              "****";
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(title),
                                                  Text(
                                                    value.isEmpty
                                                        ? "****"
                                                        : value,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ));
                                        }),
                                    const SizedBox(
                                      height: 44,
                                    ),
                                    Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            iconSize: 28,
                                            onPressed: () {
                                              PDFUtil.downloadReceipt(
                                                postDynamic,
                                              );
                                            },
                                            icon: Column(children: [
                                              Icon(
                                                color: Colors.grey,
                                                Icons.download,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text("Download",
                                                  style:
                                                      TextStyle(fontSize: 12))
                                            ])),
                                        const VerticalDivider(
                                            color: Colors.black),
                                        IconButton(
                                            iconSize: 28,
                                            onPressed: () {
                                              PDFUtil.downloadReceipt(
                                                  postDynamic,
                                                  downloadReceipt: false);
                                            },
                                            icon: Column(children: [
                                              Icon(
                                                color: Colors.grey,
                                                Icons.share,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text("Share",
                                                  style:
                                                      TextStyle(fontSize: 12))
                                            ])),
                                      ],
                                    )),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Done"))),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ])))))),
          backgroundColor: APIService.appPrimaryColor,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
