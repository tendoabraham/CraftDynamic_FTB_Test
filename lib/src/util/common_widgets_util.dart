// ignore_for_file: must_be_immutable

part of dynamic_widget;

class LoadUtil extends StatelessWidget {
  List<Color> colors;

  LoadUtil({Key? key, this.colors = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) => SpinKitWave(
        size: 54,
        itemBuilder: (BuildContext context, int index) {
          Color? isEvenColor, isOddColor;
          bool useCustomColor = false;
          if (colors.length >= 2) {
            isEvenColor = colors[0];
            isOddColor = colors[1];
            useCustomColor = true;
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? useCustomColor
                      ? isEvenColor
                      : APIService.appSecondaryColor
                  : useCustomColor
                      ? isOddColor
                      : APIService.appPrimaryColor,
            ),
          );
        },
      );
}

class EmptyUtil extends StatelessWidget {
  const EmptyUtil({super.key});

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "packages/craft_dynamic/assets/images/empty.png",
            height: 64,
            width: 64,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            "Nothing found!",
          )
        ],
      ));
}
