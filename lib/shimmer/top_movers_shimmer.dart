import 'package:crypto_app/components/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopMoversShimmer extends StatelessWidget {
  const TopMoversShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.7),
      ),
      height: Get.height * 0.18,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LoadingContainer(
                  width: 40,
                  hight: 40,
                ),
              ),
              LoadingContainer(
                width: 45,
                hight: 20,
              ),
            ],
          ),
          SizedBox(height: 33),
          Row(
            children: <Widget>[
              LoadingContainer(
                width: 80,
                hight: 20,
              ),
              SizedBox(width: 5),
              LoadingContainer(
                width: 30,
                hight: 20,
              ),
            ],
          ),
          SizedBox(height: 10),
          LoadingContainer(
            width: 50,
            hight: 20,
          ),
        ],
      ),
    );
  }
}
