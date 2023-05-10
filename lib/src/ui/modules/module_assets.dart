part of craft_dynamic;

class MenuItemImage extends StatelessWidget {
  final String imageUrl;
  double iconSize;

  MenuItemImage({super.key, required this.imageUrl, this.iconSize = 54});

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        height: iconSize,
        width: iconSize,
        placeholder: (context, url) => SpinKitPulse(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven
                    ? APIService.appPrimaryColor
                    : APIService.appSecondaryColor,
              ),
            );
          },
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
}

class MenuItemTitle extends StatelessWidget {
  final String title;

  const MenuItemTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        // overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        softWrap: true,
      );
}
