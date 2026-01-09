import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../controllers/komunitas_search_controller.dart';
import '../widgets/post_card.dart';

class SearchPostPage extends StatefulWidget {
  final UserModel user;
  const SearchPostPage({super.key, required this.user});

  @override
  State<SearchPostPage> createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  final _searchController = TextEditingController();
  final komunitasSearchController = Get.find<KomunitasSearchController>();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neutral10,
        surfaceTintColor: neutral10,
        toolbarHeight: 128,
        shape: const Border(
          bottom: BorderSide(color: neutral30),
        ),

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconsaxPlusLinear.arrow_left),
        ),

        title: Text(
          'Cari diskusi',
          style: mediumTS.copyWith(fontSize: 16, color: neutral100),
        ),
        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: CustomFormField(
              controller: _searchController,
              hint: 'Cari judul penyakit',
              backgroundColor: backgroundCanvas,
              prefixIcon: IconsaxPlusLinear.search_normal,
              prefixIconColor: neutral60,
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  komunitasSearchController.searchPost(search: value);
                });
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: komunitasSearchController.status.value == Status.loading
              ? [
                  const PostLoadingCard(),
                ]
              : komunitasSearchController.status.value == Status.success
                  ? komunitasSearchController.searchResults.isNotEmpty
                      ? komunitasSearchController.searchResults.map((post) {
                          return PostCard(user: widget.user, post: post);
                        }).toList()
                      : [
                          const DiskusiEmptyState(),
                        ]
                  : [],
        );
      }),
    );
  }
}
