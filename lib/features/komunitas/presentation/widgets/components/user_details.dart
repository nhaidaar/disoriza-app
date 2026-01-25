import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../core/common/colors.dart';
import '../../../../../core/common/custom_avatar.dart';
import '../../../../../core/common/fontstyles.dart';
import '../../../../../core/utils/format.dart';

class UserDetails extends StatelessWidget {
  final String name;
  final String? profilePicture;
  final bool isAdmin;
  final DateTime? date;
  final bool canViewReport;
  final int? reports;
  final List<Widget>? widget;
  const UserDetails({
    super.key,
    required this.name,
    this.profilePicture,
    required this.isAdmin,
    this.date,
    this.widget,
    this.canViewReport = false,
    this.reports,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomAvatar(link: profilePicture),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: mediumTS.copyWith(color: context.neutral100),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (isAdmin) const Icon(IconsaxPlusBold.verify, size: 20, color: Color(0xFF1F83FF))
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    formatTimeAgo(date),
                    style: mediumTS.copyWith(fontSize: 12, color: context.neutral60),
                  ),
                  if (canViewReport) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: CircleAvatar(radius: 2, backgroundColor: Color(0xFFD9D9D9)),
                    ),
                    Text(
                      'Dilaporkan oleh $reports orang',
                      style: mediumTS.copyWith(fontSize: 12, color: context.neutral80),
                    )
                  ]
                ],
              )
            ],
          ),
        ),
        if (widget != null) ...widget!
      ],
    );
  }
}
