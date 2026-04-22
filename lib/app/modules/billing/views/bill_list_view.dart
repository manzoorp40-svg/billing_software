import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bill_list_controller.dart';

class BillListView extends GetView<BillListController> {
  const BillListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bill List View placeholder'),
      ),
    );
  }
}
