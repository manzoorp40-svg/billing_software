import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/site_list_controller.dart';

class SiteListView extends GetView<SiteListController> {
  const SiteListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Site List View placeholder'),
      ),
    );
  }
}
