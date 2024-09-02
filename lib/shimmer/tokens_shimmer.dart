import 'package:crypto_app/components/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokensShimmer extends StatelessWidget {
  const TokensShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      // margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: Colors.white.withOpacity(0.7),
      ),
      width: 348,
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LoadingContainer(
                width: 40,
                hight: 40,
              ),
            ),
            title: LoadingContainer(
              width: 30,
              hight: 12,
            ),
            subtitle: LoadingContainer(
              width: 25,
              hight: 12,
            ),
            trailing: LoadingContainer(
              width: 40,
              hight: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
