import 'package:flutter/material.dart';

import 'custom_text.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator.adaptive(),
          SizedBox(
            height: 10,
          ),
          CustomText(text: "Loading ...")
        ],
      ),
    );
  }
}
