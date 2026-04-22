import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/unit_list_controller.dart';

class UnitListView extends GetView<UnitListController> {
  const UnitListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Unit List View placeholder'),
      ),
    );
  }
}
