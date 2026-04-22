import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_list_controller.dart';

class PurchaseListView extends GetView<PurchaseListController> {
  const PurchaseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Purchase List View placeholder'),
      ),
    );
  }
}
