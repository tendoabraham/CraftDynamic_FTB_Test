import 'package:flutter/material.dart';

class ListDataScreen extends StatelessWidget {
  final Widget widget;
  final String title;

  const ListDataScreen({super.key, required this.widget, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: (() {
      //       Navigator.of(context).pop();
      //     }),
      //     icon: const Icon(
      //       Icons.arrow_back,
      //     ),
      //   ),
      //   title: Text(title),
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 15),
            child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  //set border radius more than 50% of height and width to make circle
                ),
                color: const Color.fromARGB(255, 0, 80, 170),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
                          child: Text(
                        title,
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
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            color: const Color.fromARGB(255, 219, 220, 221),
            child: widget,
          ))
        ],
      ),
    );
  }
}
