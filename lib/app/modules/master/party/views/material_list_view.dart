import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/material_list_controller.dart';

class MaterialListView extends GetView<MaterialListController> {
  const MaterialListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Material List View placeholder'),
      ),
    );
  }
}
