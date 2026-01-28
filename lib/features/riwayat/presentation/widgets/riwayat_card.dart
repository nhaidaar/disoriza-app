import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/utils/format.dart';
import '../../data/models/riwayat_model.dart';
import '../pages/riwayat_detail.dart';

class RiwayatCard extends StatelessWidget {
  final RiwayatModel riwayatModel;

  const RiwayatCard({super.key, required this.riwayatModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => RiwayatDetail(riwayat: riwayatModel)),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        decoration: BoxDecoration(
          color: context.neutral10,
          borderRadius: defaultSmoothRadius,
          boxShadow: const [shadowEffect1],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: riwayatModel.urlImage.toString(),
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/example.jpg',
                  height: 102,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
              height: 102,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    riwayatModel.idDisease!.name.toString(),
                    style: mediumTS.copyWith(color: context.neutral100),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTimeAgo(riwayatModel.date),
                    style: mediumTS.copyWith(
                      fontSize: 12,
                      color: context.neutral70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiwayatLoadingCard extends StatelessWidget {
  const RiwayatLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(4, (index) {
        return CardLoading(
          height: 160,
          width: MediaQuery.of(context).size.width / 2 - 24,
          borderRadius: BorderRadius.circular(16),
          cardLoadingTheme: CardLoadingTheme(
            colorOne: context.neutral30,
            colorTwo: context.neutral40,
          ),
        );
      }),
    );
  }
}
