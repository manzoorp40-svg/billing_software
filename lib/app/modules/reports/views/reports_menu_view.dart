import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reports_controller.dart';

class ReportsMenuView extends GetView<ReportsController> {
  const ReportsMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Reports Menu View placeholder'),
      ),
    );
  }
}
