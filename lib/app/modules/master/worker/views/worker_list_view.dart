import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/worker_list_controller.dart';

class WorkerListView extends GetView<WorkerListController> {
  const WorkerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Worker List View placeholder'),
      ),
    );
  }
}
